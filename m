Return-Path: <linux-kernel-owner+w=401wt.eu-S965098AbXA3Pw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098AbXA3Pw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965092AbXA3Pw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:52:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:54207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965098AbXA3Pw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:52:57 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch] raw: don't allow the creation of a raw device with minor number 0
To: Dave Jones <davej@redhat.com>, Dave Jones <davej@redhat.com>,
       jmoyer@redhat.com, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Fernandez <sfernand@redhat.com>, Andrew Morton <akpm@osdl.org>
Reply-To: 7eggert@gmx.de
Date: Tue, 30 Jan 2007 16:52:08 +0100
References: <7CxBM-2pk-23@gated-at.bofh.it> <7CDnP-30W-9@gated-at.bofh.it> <7CDxA-3cL-9@gated-at.bofh.it> <7IoP7-5nQ-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HBvHE-000165-9r@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX19Dorsq8oMV+RPh+MMuBhS/WC/+FyMVotRAXHfBqXKtfuobHg2CxbnqFuPfCqX3XtkIDpl+SXU7hWgE+f+/iTwvrTQitj8XEWHTS80cxtBSzA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> wrote:
> On Fri, Jan 12, 2007 at 05:58:41PM -0500, jmoyer@redhat.com wrote:

>  > jengelh>   What:   RAW driver (CONFIG_RAW_DRIVER)
>  > jengelh>   When:   December 2005
>  > jengelh>   Why:    declared obsolete since kernel 2.6.3
>  > jengelh>           O_DIRECT can be used instead
>  > jengelh>   Who:    Adrian Bunk <bunk@stusta.de>
>  > 
>  > It's still present, still used, and so would benefit from being fixed, in
>  > my opinion.

ACK, it's a bug, the patch is there, and AFAIR it's simple and correct. Maybe
it is suitable for the stable branch, too. If the RAW driver isn't removed,
it should be applied.

> Given the tirade against O_DIRECT on linux-kernel earlier this month,
> it has me wondering about the validity of this entry.

O_DIRECT on devices is accepted by Linus, since it has much less corner
cases.

> Every time we've tried to deprecate this driver in Fedora/RHEL, we've
> had enough people complain that we've ended up having to turn it back on.
> (And I'm fairly sure other distros have been in the same position).
> Some vendors seem way too attached to the older semantics than having
> to rewrite their apps to use O_DIRECT, and unnecessarily breaking them
> so that we can throw away a 306 line driver in the name of cleanliness
> seems a bit gratuitous.

It must be hard to add #ifndef O_DIRECT / #define O_DIRECT 0 / #endif
and to add O_DIRECT to the apropiate open calls ...

(I peeked into the driver, and it seems it's just a wrapper creating an alias
 and opening the associated block-device O_DIRECT.)
-- 
We are all born ignorant, but one must work hard to remain stupid.
        -- Benjamin Franklin

Friﬂ, Spammer: zOfbszC@c7h.7eggert.dyndns.org dr@mnpqOUpA.7eggert.dyndns.org
