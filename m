Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbYIJRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbYIJRIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYIJRIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:08:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:33990 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYIJRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gL48LRAqW/5mZGtEOTqPWCeY94w47xQF5QV+UJidm9DZIfJIoUmD4WPC6m5Msnr23n
         qtzlZH5ZeZ6nByUMtnd7RaRpykTPHBZts91DsceMeTNDNVbRIQWxT0L0sPbQYrYbfkOP
         DeY1AZmQ+XJv8U++GVcC/oriYOFl9G6TOJYhY=
Message-ID: <2c0942db0809101008j55ea39dfx8dbf6284d4de749@mail.gmail.com>
Date: Wed, 10 Sep 2008 10:08:07 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: hamid.jahanjou@gmail.com
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Cc: "Rik van Riel" <riel@redhat.com>, "Zan Lynx" <zlynx@acm.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48C78246.7050507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BFCECE.90103@gmail.com> <87iqtbuez9.fsf@basil.nowhere.org>
	 <48C19648.8030002@gmail.com>
	 <20080905194501.GZ18288@one.firstfloor.org>
	 <20080906014214.22f28548@riellaptop.surriel.com>
	 <48C471AE.8060809@acm.org>
	 <20080907205536.0d1937ff@riellaptop.surriel.com>
	 <48C78246.7050507@gmail.com>
X-Google-Sender-Auth: 272ea9160ea37888
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 1:16 AM, Hamid R. Jahanjou
<hamid.jahanjou@gmail.com> wrote:
> I agree. As you said, we have two conflicting requirements here: on the
> one hand one likes to swap as many pages as to satisfy the backing
> storage "proper block IO size," on the other hand, one should not make a
> process lose too many pages.

I'd much rather that one process lose a lot of pages than many
processes lose a few. When a system is swap thrashing, each process
has some of its active working set tossed to swap, which means *any*
application you try to switch to is then sluggish. If it were only one
application, then only that one takes the penalty hit when the user
switches focus and context.
