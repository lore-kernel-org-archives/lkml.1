Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZHTVuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZHTVuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZHTVux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:50:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34386 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZHTVuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:50:52 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: John David Anglin <dave@hiauly1.hia.nrc.ca>, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       dave.anglin@nrc.ca, roland@redhat.com
In-Reply-To: <4A8DC3ED.4060005@gmx.de>
References: <20090820185550.979544E7A@hiauly1.hia.nrc.ca>
	 <4A8DC3ED.4060005@gmx.de>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 15:50:49 -0600
Message-Id: <1250805049.4302.121.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 23:45 +0200, Helge Deller wrote:
> On 08/20/2009 08:55 PM, John David Anglin wrote:
> >> The reason seems to be, that something in the newer gcc compilers changed to generate multiple sections all named ".text" for the PCREL17 relocations.
> >> Older compilers named those sections ".text.1", ".text.2", ".text.3" and so forth.
> >
> > GCC has never generated ".text.1", etc, on parisc linux as far as I know.
> 
> Hmm, I don't like to disagree with an gcc-expert like you,but
> I did pasted an objdump in my last mail, which shows that gcc did
> generated .text.1, .text.2 and so on:
> 
> Sections:
> Idx Name          Size      VMA       LMA       File off  Algn
>    0 .text         00000000  00000000  00000000  00000034  2**0
>                    CONTENTS, ALLOC, LOAD, READONLY, CODE
> ...
>    4 .text.1       00000000  00000000  00000000  000000b0  2**0
>                    CONTENTS, ALLOC, LOAD, READONLY, CODE

Since this is a relinked object, might it be possible that ld rather
than gcc is the culprit?

James


