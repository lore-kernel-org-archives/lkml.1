Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXHTLqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXHTLqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbXHTLpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXHTLpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:45:55 -0400
Date: Mon, 20 Aug 2007 13:45:44 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@home.nl>
cc: Bodo Eggert <7eggert@gmx.de>, Mike Mohr <akihana@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: group ownership of tun devices -- nonfunctional?
In-Reply-To: <46C8D124.4030701@home.nl>
Message-ID: <Pine.LNX.4.58.0708201324570.2672@be1.lrz>
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz>
 <46C86B6C.8090209@home.nl> <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
 <46C8D124.4030701@home.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19/HWbmjA5RqaEzBN0GDCRJUJkXstQ3WvYUZq7
 iFzmk0+RI78NP63vKJ0fzAgfr5y5aHwu9q3OAQMnADUry6J52X
 rOUzuWRt/r6nf0Wgoqc2Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Rene Herman wrote:
> On 08/19/2007 11:42 PM, Bodo Eggert wrote:

> > The intended [my me] semantics is If the user is not
> >  * the allowed user
> > or
> >  * member of the allowed group
> > or
> >  * cabable of CAP_NET_ADMIN
> > then error out. I'm asuming
> 
> There is a short description of the desired semantics in the link that was 
> posted:
> 
> http://lkml.org/lkml/2007/6/18/228
> 
> ===
> The user now is allowed to send packages if either his euid or his egid
> matches the one specified via tunctl (via -u or -g respecitvely). If both
> gid and uid are set via tunctl, both have to match.
> ===
> 
> Paraphrasing the original code above, it's saying:
> 
> if ((owner_is_set && does_not_match) || (group_is_set && does_not_match))
> 	bugger_off_unless(CAP_NET_ADMIN);
> 
> or reverting the logic:
> 
> if ((owner_is_unset || does_match) && (group_is_unset || does_match))
> 	good_to_go();
> 
> which probably matches the intention -- we're good to go only if the 
> credentials that are set also match.

Maybe there are valid reasons to do it this way, but I think having it the 
way I described would be less confusing.

-- 
       ¤ Bill of Spammer-Rights ¤
1. We have the right to assassinate you.
2. You have the right to be assassinated.
3. You have the right to resist, but it is futile.
