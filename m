Return-Path: <linux-kernel-owner+w=401wt.eu-S1422721AbXCOO0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbXCOO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 10:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422722AbXCOO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 10:26:00 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43845 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422721AbXCOOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 10:25:59 -0400
Message-Id: <1173968759.13755.1179613375@webmail.messagingengine.com>
X-Sasl-Enc: +QDX5CJjOH7ExiWCRdv56LOrrHViBcgRvIF0ePoPm4G9 1173968759
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: sbhushan@cadence.com, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <45F92C1E.2040604@cadence.com>
Subject: Re: Files not visible across NFS
In-Reply-To: <45F92C1E.2040604@cadence.com>
Date: Thu, 15 Mar 2007 15:25:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 16:51:02 +0530, "Sai Bhushan" <sbhushan@cadence.com>
said:
> Hi,
> 
> I am facing a problem where-in some files are not visible across NFS and 
> hence, not able to read those files. However, after sometime, the files 
> become visible and the data is accessible. I have tried to do an 'ls -l' 
> operation on the directory and repeat it till the directory gets mounted 
> and visible. This works in some cases but sometimes fails as well.
> 
> Is there any reliable way of ensuring that the directory gets mounted 
> and all files in it are visible before accessing the data ??
> 
> Any help/pointers in this regard would be really great.

Hi,

Many Ubuntu users seem to be experiencing such problems on ubuntu-2.6.17
kernels:

https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/62308

In my experience, everything works fine as long as all
directory-elements in 
the path on the nfs mount are set executable for user _and_others_. If
that
is not the case, files are available for about five seconds after the
first
access, after which they disappear. If I try to access the file again I
get 
a "permission denied" message. No messages get logged.

For me, adding the "no_subtree_check" option in /etc/exports 'fixed' the
problem. I'm on ubuntu-2.6.17-11-generic on amd64. This works for me:

/home    
192.168.22.0/255.255.255.0(rw,sync,no_subtree_check,mp=/home,fsid=12120)
/scratch 
192.168.22.0/255.255.255.0(rw,sync,no_subtree_check,mp=/scratch,fsid=12121)

Anyhow, you did not give any information about your
distro/kernel/hardware?

Greetings,
    Alexander

> -Thanks & Regards
> Sai
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

