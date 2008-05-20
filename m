Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbYETSpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbYETSpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYETSpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:45:03 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:35079 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbYETSpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F2OwQuxkV+tFMD8yD8w5Ryjhrk9TovrbWSvsYOS0cMh2VEO5y2LVBBNSDqFE/A43s8qow7oxtWsW7SUz8GP3wLgokwtKLv6TJTxIQMQoB26LrSfjBGO2F0OeKyN5oSXa2GkLRulEa2WCNg9dAwpf+87c+1CAjA5dzpt5NOPSfB4=
Message-ID: <a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com>
Date: Tue, 20 May 2008 11:44:56 -0700
From: "Greg Steuck" <greg@nest.cx>
To: linux-kernel@vger.kernel.org
Subject: Fwd: include/linux/netfilter.h after make headers_install is incomplete
In-Reply-To: <a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a27c0c970805161521k332fba8cg808d52396b5cdce5@mail.gmail.com>
	 <a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com>
X-Google-Sender-Auth: 731cd2d714cfab0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I asked this on netfilter list, but it doesn't seem to be generating any
interest there. Maybe the question belongs on this list?

I ran make headers_install in 2.6.25 tree and the installed netfilter.h is
not complete. Namely, it declares
union nf_inet_addr {
      __u32           all[4];
      __be32          ip;
      __be32          ip6[4];
...
}

The __u32, __be32 types are declared in <linux/types.h> and the #include
directive is removed by the installation process. This in turn makes some
applications unbuildable against such an exported tree, e.g.

busybox-1.10.1/networking/tcpudp.c:#include <linux/netfilter_ipv4.h>

If I correctly understand the purpose of make headers_install, it is
supposed to generate an API for applications. I could certainly
make tcpudp.c include linux/types.h, but given that the application
does not even use nf_inet_addr, this would be the wrong place for
the fix.

Is kernel the right place then?

Thanks
Greg
--
nest.cx is Gmail hosted, use PGP for anything private. Key:
http://tinyurl.com/ho8qg
Fingerprint: 5E2B 2D0E 1E03 2046 BEC3  4D50 0B15 42BD 8DF5 A1B0
