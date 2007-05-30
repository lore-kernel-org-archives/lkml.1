Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXE3FnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXE3FnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXE3FnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:43:07 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45263 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXE3FnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:43:06 -0400
Message-ID: <465D0ED5.3070305@novell.com>
Date: Wed, 30 May 2007 01:42:45 -0400
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Cliffe <cliffe@iinet.net.au>, casey@schaufler-ca.com,
       Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465AE46B.4090109@iinet.net.au> <465B57D7.2040101@novell.com> <20070529144518.GD5840@ucw.cz>
In-Reply-To: <20070529144518.GD5840@ucw.cz>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>     * Hard links: AppArmor explicitly mediates permission to make a hard
>>     
> Unfortunately, aparmor is by design limited to subset of distro
> (network daemons).
That is not true. AppArmor is designed to confine any application you do
not want to trust completely. This includes network daemons (Apache,
Sendmail, BIND, etc.) network clients (Firefox, Thunderbird,
GAIM/Pidgin, etc.) and any other application that mediates trust: where
data on one side of the application is higher privilege than potential
attackers on the other side of the application.

>  Unfortunately, some other programs (passwd, vi)
> routinely make hardlinks. So AA mediating hardlink is not enough, as
> vi will happily hardlink /etc/shadow into /etc/.vi-shadow-1234.
>   
I have no idea what you are talking about. I routinely profile vim on
stage in AppArmor presentations, and it presents no such problems.

Caveat: the circumstances under which you would actually want to profile
vi are rather limited, most users would not want to do that.

In another post Pavel Machek wrote:
> Hmm, I guess I'd love "it is useless on multiuser boxes" to become
> standard part of AA advertising.
That is usually around slide 7 of the standard AppArmor presentation,
right next to the remarks about how mulituser boxes are nearly extinct
dinosaurs. AppArmor gets some of its simplicity and ease of use by not
considering that vanishing use case. Even so, AppArmor does have uses on
multiuser boxes, just not the uses Pavel wishes for. Fine, use a
different tool for a different task, AppArmor has plenty of use cases.

The limitation Pavel is referring to is that AppArmor does not secure
processes that are not profiled by AppArmor. We know, this is
intentional, and contributes to AppArmor's ease of use, and does not
generate a hole if you consider every process exposed to (say) network
attack and confine it.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
		   Security: It's not linear

