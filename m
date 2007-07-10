Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXGJMf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXGJMf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXGJMfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:35:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:49883 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbXGJMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gzPZOtOvRRKYRpO88y67c1ATqm1WfOzbYFoNyJ0d3uFsFP3oP6V4JZfOyV+3Fp1RGFAnQxQzfcWeEfn1xgOaQX+w6bIE+3/Xh2JAt4XT6m17gBbXv1T6NXRVUDOp3Pu4AWA5EbY5euffmRU1tLSVH+BC6cZp5jI87VDkcS7d9E4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v2 -mm 4/9] netconsole: Add some useful tips to documentation
Date: Tue, 10 Jul 2007 14:34:39 +0200
User-Agent: KMail/1.9.7
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jesper Juhl <jesper.juhl@gmail.com>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091941.23907.45658.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710094142.GM11115@waste.org>
In-Reply-To: <20070710094142.GM11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101434.39938.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 11:41:43 Matt Mackall wrote:
> On Tue, Jul 10, 2007 at 02:49:41PM +0530, Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> >
> > [4/9] netconsole: Add some useful tips to documentation
> >
> > Add some useful general-purpose tips.
> >
> > Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>
>
> Acked-by: Matt Mackall <mpm@selenic.com>
>
> As long as we're on the subject, I've been meaning to add a note
> telling people to set their console log level to something useful, as
> having that set too low is the most common problem people encounter.

How about this?


From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Add some useful general-purpose tips.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

---

 Documentation/networking/netconsole.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 1caa6c7..ffd5058 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -44,11 +44,29 @@ WARNING: the default target ethernet setting uses the broadcast
 ethernet address to send packets, which can cause increased load on
 other systems on the same ethernet segment.
 
+TIP: some LAN switches may be configured to suppress ethernet broadcasts
+so it is advised to explicitly specify the remote agents' MAC addresses
+from the config parameters passed to netconsole.
+
+TIP: to find out the MAC address of, say, 10.0.0.2, you may try using:
+
+ ping -c 1 10.0.0.2 ; /sbin/arp -n | grep 10.0.0.2
+
+TIP: in case the remote logging agent is on a separate LAN subnet than
+the sender, it is suggested to try specifying the MAC address of the
+default gateway (you may use /sbin/route -n to find it out) as the
+remote MAC address instead.
+
 NOTE: the network device (eth1 in the above case) can run any kind
 of other network traffic, netconsole is not intrusive. Netconsole
 might cause slight delays in other traffic if the volume of kernel
 messages is high, but should have no other impact.
 
+Some people forget to raise the kernels log_level to an
+appropriate level and thus don't see all the kernel log messages they
+expect. You can add the kernel boot option "ignore_loglevel" to see all
+messages or you can use SysRq to set the log level to a specific value.
+
 Netconsole was designed to be as instantaneous as possible, to
 enable the logging of even the most critical kernel bugs. It works
 from IRQ contexts as well, and does not enable interrupts while




