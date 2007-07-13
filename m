Return-Path: <linux-kernel-owner+w=401wt.eu-S935915AbXGMTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915AbXGMTJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXGMTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:09:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14638 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbXGMTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=O8o+l25gtiNj/YVgi3So062R8zTM53AxdqFUQMnD6ynJI6CwXU0py32owCyHr64HPSq9KE19zZNRhonoDfyAh6b648ZrfIDIqXe9VkmoO2+HLt1rEbCy+SqK/SMfiqRcLGg9++hHixenW4xhgZfmZG/viGZJ0TQP/7v3a91DL1A=
Message-ID: <4697CDB5.1060708@googlemail.com>
Date: Fri, 13 Jul 2007 21:08:37 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: jmorris@namei.org, michal.k.k.piotrowski@gmail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: The art of breaking userspace (was Re: [GIT] SELinux changes for
 2.6.23 (updated))
References: <3267153665.17485311@mail.hp.com>
In-Reply-To: <3267153665.17485311@mail.hp.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore pisze:
[..]
> On Fri, 13 Jul 2007, Michal Piotrowski wrote:
>> My system is too secure, I can not login :)
>>
>> Do you have CONFIG_NETLABEL=y ?
>>
>> If so, please try disabling it.
> 
> Disabling NetLabel should solve the problem.

Disabling NetLabel solves the problem.

>  The recommended solution to this problem, as discussed on the SELinux list and mentioned in the patch description, is to upgrade your SELinux policy to the latest Reference Policy sources.  For those with custom SELinux policy, the patch description explains the changes to the SELinux policy required. 

I'm sorry to say this, but this kind of patches should not be accepted.

Patch

commit 9faf65fb6ee2b4e08325ba2d69e5ccf0c46453d0
Author: Paul Moore <paul.moore@hp.com>
Date:   Fri Jun 29 11:48:16 2007 -0400

    SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel

    These changes will make NetLabel behave like labeled IPsec where there is an
    access check for both labeled and unlabeled packets as well as providing the
    ability to restrict domains to receiving only labeled packets when NetLabel
    is in use.  The changes to the policy are straight forward with the
    following necessary to receive labeled traffic (with SECINITSID_NETMSG
    defined as "netlabel_peer_t"):

     allow mydom_t netlabel_peer_t:{ tcp_socket udp_socket rawip_socket } recvfrom;

    The policy for unlabeled traffic would be:

     allow mydom_t unlabeled_t:{ tcp_socket udp_socket rawip_socket } recvfrom;

    These policy changes, as well as more general NetLabel support, are included
    in the SELinux Reference Policy SVN tree, r2352 or later.  Users who enable
    NetLabel support in the kernel are strongly encouraged to upgrade their
    policy to avoid network problems.

    Signed-off-by: Paul Moore <paul.moore@hp.com>
    Signed-off-by: James Morris <jmorris@namei.org>


breaks systems with recent selinux policy.

(rpm -qa selinux-policy-*
selinux-policy-devel-2.6.4-25.fc7
selinux-policy-targeted-2.6.4-25.fc7)

I will add this as a regression unless Linus says "Fsck it! We don't care about compatibility"

> 
> If needed I can post more instructions later, let me know, but right now I'm tapping this out on my phone while at the airport.
> 
> . paul moore
> . linux security @ hp
> 
> 
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
