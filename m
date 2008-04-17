Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYDQC4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYDQC4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 22:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYDQCz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 22:55:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:64638 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYDQCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 22:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OcYeNAypgwf3nvjp9y7ya6EUdlE6025x09ZyIgqf4E8IKGGDYaMfufE2z+9WD7nJDlz0J5DCeuTbQMSROV2RV8rG2VXPoVBawXtp39WfpWejvHIb0c2iZjV1pDtdjIrA2SeeHxG8VfLloLk3LkIHVbqpWX98t4gARmFYazjq5po=
Message-ID: <ed10ee420804161955o221539f9p5cbfcc9eaf4b375d@mail.gmail.com>
Date: Wed, 16 Apr 2008 19:55:52 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: gart: factor out common code
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080416081418.GA5105@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415104357.GA13441@elf.ucw.cz>
	 <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>
	 <20080416081418.GA5105@elf.ucw.cz>
X-Google-Sender-Auth: 158ee870a4b1fdce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/08, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2008-04-15 16:25:29, SL Baur wrote:
>  > On 4/15/08, Pavel Machek <pavel@ucw.cz> wrote:

>  > Other reviewer comments:
>  > The casting between struct pci_dev * and u64 is kind of ugly,
>  > I presume the reason for the narrowing casts in the block of
>  > code you moved is documented somewhere.
>
>
> Where am I doing that?

The struct pci_dev */u64 casting is in init_k8_gatt.  If Ingo is happy, then
forget my comment.  I don't have this kind of system to test the patch on, it
was just that as I was looking it over, all the casts kind of made my head
swim.

The narrowing cast is here:
+static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
+{
+       u32 tmp, ctl;
+
+        /* address of the mappings table */
+        addr >>= 12;
+        tmp = (u32) addr<<4;

Also, putting on my Andrew Morton cap, which I should have done before,
that function is too big to be inlined so you should probably drop the explicit
`inline' and let the compiler decide.

Add a
Reviewed-by: SL Baur <steve@xemacs.org>
if that's appropriate.  I'm satisified that you did a one-for-one code move.

-sb
