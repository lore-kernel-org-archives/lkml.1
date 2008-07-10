Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbYGJRKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbYGJRKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYGJRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:10:35 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:50325 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYGJRKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:10:34 -0400
Subject: Re: nfs root error after modprobe iptable_nat
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
In-Reply-To: <48760ECF.1060103@hiramoto.org>
References: <48760ECF.1060103@hiramoto.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 13:10:29 -0400
Message-Id: <1215709829.7126.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B7103CA215BE719EF1E44D04D0B5A5B0D8ACAAEB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 52 total 9164017 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 15:29 +0200, Karl Hiramoto wrote:
> Hi all,
> 
> loading nf_nat seems to cut my NFS root connection.
> 
> # modprobe iptable_nat
> nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> # nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> 
> 
> 
> 12:23:35.335832 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
> UDP (17), length 136) 192.168.10.54.4259114599 > 192.168.10.51.2049: 108
> lookup [|nfs]
> 12:23:35.335920 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
> UDP (17), length 56) 192.168.10.51.2049 > 192.168.10.54.4259114599:
> reply ok 28 lookup ERROR: No such file or directory
> 12:23:35.336611 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
> UDP (17), length 136) 192.168.10.54.4259114600 > 192.168.10.51.2049: 108
> lookup [|nfs]
> 12:23:35.336650 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
> UDP (17), length 56) 192.168.10.51.2049 > 192.168.10.54.4259114600:
> reply ok 28 lookup ERROR: No such file or directory
> 
> 
> 
> NFS server:
> uname -a
> Linux karl-d820 2.6.25.10 #1 SMP Thu Jul 10 10:15:44 CEST 2008 i686
> Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel GNU/Linux
> 
> 
> 
> NFS Client:
> # uname -a
> Linux NSB 2.6.25.10 #6 Thu Jul 10 13:04:15 CEST 2008 armv5teb unknown
> uclibc 0.29
> Intel  IXP425
> 
> 
> On the server there are no error messages.  without loading NAT 
> everything seems to work fine.
> 
> 
> Comping NAT directly into the kernel also has the same results.
> 
> 
> Not sure if i have something configured wrong, or if this is related to 
> the patches sent by Trond a few days ago.

errno 1 is the same as EPERM (i.e. permission denied). I'm not sure what
is returning that error, but it isn't the NFS or SUNRPC layer.

Have you tried a 'git bisect'?

Cheers
  Trond

