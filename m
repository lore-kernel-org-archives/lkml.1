Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIJDDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIJDDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIJDCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:02:49 -0400
Received: from fbx.plessis.info ([82.240.245.101]:58299 "EHLO
	amon.plessis.info" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbYIJDCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:02:47 -0400
X-Greylist: delayed 668 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 23:02:47 EDT
Message-ID: <48C73633.9030300@plessis.info>
Date: Wed, 10 Sep 2008 04:51:31 +0200
From: Benoit Plessis <benoit@plessis.info>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've just found this thread, and i'm relieved in some way, that i'm not 
the only one
experiencing this.

NFS Server: NetApp Data On Tap v 7.2.4 (not changed

NFS Client: Dell and HP machines, using Broadcom network card
    # ethtool -i eth0
    driver: bnx2
    version: 1.7.4
    firmware-version: 4.0.3 UMP 1.1.9
    bus-info: 0000:05:00.0

All machines are running on NFS Root on local LAN. Previous 
configuration with kernel 2.6.22.14
was working quite fine except for some quick lost, solved within a few 
second
    Sep 10 01:03:54 kernel: nfs: server 10.250.255.253 not responding, 
still trying
    Sep 10 01:03:54 kernel: nfs: server 10.250.255.253 OK
That's already something strange that shouldn't happens

And now, after an upgrade to 2.6.25.16:
Sep 10 03:26:31 web-31-mtp-1 kernel: nfs: server 10.250.255.253 not 
responding, still trying
Sep 10 03:27:40 web-31-mtp-1 kernel: INFO: task apache2:29263 blocked 
for more than 120 seconds.
Sep 10 03:27:40 web-31-mtp-1 kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 10 03:27:40 web-31-mtp-1 kernel: apache2       D 
0000000000000000     0 29263   2288
Sep 10 03:27:40 web-31-mtp-1 kernel:  ffff81005d1ad958 0000000000200086 
0000000000000000 ffff810001005830
Sep 10 03:27:40 web-31-mtp-1 kernel:  ffff81009f8c8080 ffffffff805734a0 
ffff81009f8c82b8 0000000100970659
Sep 10 03:27:40 web-31-mtp-1 kernel:  00000000ffffffff 0000000000000000 
0000000000000000 0000000000000000
Sep 10 03:27:40 web-31-mtp-1 kernel: Call Trace:
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8046ac20>] 
rpc_wait_bit_killable+0x0/0x40
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8046ac3c>] 
rpc_wait_bit_killable+0x1c/0x40
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80493f4f>] 
__wait_on_bit+0x4f/0x80
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8046ac20>] 
rpc_wait_bit_killable+0x0/0x40
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80493ffa>] 
out_of_line_wait_on_bit+0x7a/0xa0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80249350>] 
wake_bit_function+0x0/0x30
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff804672d3>] 
xprt_connect+0x83/0x170
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8046b141>] 
__rpc_execute+0xd1/0x280
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff804644e1>] 
rpc_run_task+0x51/0x70
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8046459c>] 
rpc_call_sync+0x3c/0x60
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802edbba>] 
nfs3_rpc_wrapper+0x3a/0x60
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802ee2f1>] 
nfs3_proc_access+0x141/0x240
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8029d51f>] dput+0x1f/0xf0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802e0abf>] 
nfs_lookup_revalidate+0x22f/0x3e0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80249529>] 
remove_wait_queue+0x19/0x60
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80298c91>] 
free_poll_entry+0x11/0x20
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80298ccc>] 
poll_freewait+0x2c/0x90
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80299026>] 
do_sys_poll+0x2f6/0x370
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802dee71>] 
nfs_do_access+0xe1/0x340
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802df1aa>] 
nfs_permission+0xda/0x1a0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80292d1d>] 
permission+0xbd/0x150
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80294b7e>] 
__link_path_walk+0x7e/0xee0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff803e865b>] 
sock_aio_read+0x16b/0x180
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80295a3a>] 
path_walk+0x5a/0xc0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80295cc3>] 
do_path_lookup+0x83/0x1c0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802947a5>] 
getname+0xe5/0x210
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802968bb>] 
__user_walk_fd+0x4b/0x80
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff8028eacf>] 
vfs_stat_fd+0x2f/0x80
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff802255af>] 
sys32_stat64+0x1f/0x50
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80327df1>] 
__up_read+0x21/0xb0
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff804955c9>] 
error_exit+0x0/0x51
Sep 10 03:27:40 web-31-mtp-1 kernel:  [<ffffffff80224dd2>] 
ia32_sysret+0x0/0xa
Sep 10 03:27:40 web-31-mtp-1 kernel:
Sep 10 03:27:40 web-31-mtp-1 kernel: INFO: task apache2:29339 blocked 
for more than 120 seconds.
Sep 10 03:27:40 web-31-mtp-1 kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
....
Sep 10 03:31:56 web-31-mtp-1 kernel: nfs: server 10.250.255.253 OK

During this time the serveur isn't available, albeit it still reply to 
icmp message.
I've a bunch of identical server with this new kernel, and this doesn't 
happen on every one.
Only 30% of then seem to be affected.
All machines are running the latest same BIOS/Network Firmware.
Also all machines are using a bonded interface in failover mode.

There is no particular messages on the netapp side, only this common 
message:

    Average size of NFS TCP packets received from host: X.X.X.X is 3858.
    This is less than the MTU (9000 bytes) of the interface involved in
    the data transfer.
    The maximum segment size being used by TCP for this host is: 8960.
    Low average size of packets received by this system might be
    because of a misconfigured client system, or a poorly written
    client application.
    Press enter to continue

There isn't even any "retransmission timeouts" recorded during the 
client side hang.

The kernel is a vanilla 2.6.25.16 compiled for amd64 architecture with 
bnx2 and NFS root included in the kernel.
I'll try the latest 2.6.24 and then revert to 2.6.22 if necessary


And 'voila',
that's all i can think of at this time, don't hesitate to ask for more 
informations.


Oh yes, the first problems appeared on one machine while his twin sister 
doesn't have any trouble,
the only difference at this time was the value of 
"net.core.netdev_max_backlog" (2500 on the machine without
trouble, 1000 on the other). But now this happens on machines with the 
exact same configuration,
without many sysctl tweak, only:
    # increase TCP max buffer size
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    # increase Linux autotuning TCP buffer limits
    # min, default, and max number of bytes to use
    net.ipv4.tcp_rmem = 4096 87380 16777216
    net.ipv4.tcp_wmem = 4096 65536 16777216

    # don't cache ssthresh from previous connection
    net.ipv4.tcp_no_metrics_save = 1
    # recommended to increase this for 1000 BT or higher
    net.core.netdev_max_backlog = 2500


PS: Please CC me the reply

-- 
Benoit

