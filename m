Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbXISX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbXISX1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXISX1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:27:18 -0400
Received: from mx28.mail.ru ([194.67.23.67]:19972 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbXISX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:27:17 -0400
From: Ilya Eremin <che_guevara_3@bk.ru>
To: linux-kernel@vger.kernel.org
Subject: Out of socket memory
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [86.135.197.16]
Date: Thu, 20 Sep 2007 03:26:33 +0400
Reply-To: Ilya Eremin <che_guevara_3@bk.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1IY8wD-000IAC-00.che_guevara_3-bk-ru@f102.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am running a P2P related server, which has many connections to it at one time (about 100,000 at peak times). But I have been getting
eserver invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0 errors followed by
Out of socket memory
I believe this is related to rmem, but I am not sure. Here's my current net related sysctl settings

net.core.wmem_max = 8388608
net.core.rmem_max = 8388608
net.core.wmem_default = 104448
net.core.rmem_default = 104448
net.core.dev_weight = 64
net.core.netdev_max_backlog = 1024
net.core.message_cost = 5
net.core.message_burst = 10
net.core.optmem_max = 40960
net.core.xfrm_aevent_etime = 10
net.core.xfrm_aevent_rseqth = 2
net.core.xfrm_larval_drop = 0
net.core.xfrm_acq_expires = 30
net.core.somaxconn = 1024
net.core.netdev_budget = 300
net.core.warnings = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_retrans_collapse = 1
net.ipv4.ip_forward = 0
net.ipv4.ip_default_ttl = 64
net.ipv4.ip_no_pmtu_disc = 0
net.ipv4.ip_nonlocal_bind = 0
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_synack_retries = 5
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_tw_buckets = 360000
net.ipv4.ipfrag_high_thresh = 262144
net.ipv4.ipfrag_low_thresh = 196608
net.ipv4.ip_dynaddr = 0
net.ipv4.ipfrag_time = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_fin_timeout = 25
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.ip_local_port_range = 32768    61000
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
error: permission denied on key 'net.ipv4.route.flush'
net.ipv4.route.min_delay = 2
net.ipv4.route.max_delay = 10
net.ipv4.route.gc_thresh = 32768
net.ipv4.route.max_size = 524288
net.ipv4.route.gc_min_interval = 0
net.ipv4.route.gc_min_interval_ms = 500
net.ipv4.route.gc_timeout = 150
net.ipv4.route.gc_interval = 1
net.ipv4.route.redirect_load = 2
net.ipv4.route.redirect_number = 9
net.ipv4.route.redirect_silence = 2048
net.ipv4.route.error_cost = 100
net.ipv4.route.error_burst = 500
net.ipv4.route.gc_elasticity = 6
net.ipv4.route.mtu_expires = 600
net.ipv4.route.min_pmtu = 552
net.ipv4.route.min_adv_mss = 256
net.ipv4.route.secret_interval = 600
net.ipv4.igmp_max_msf = 10
net.ipv4.inet_peer_threshold = 65664
net.ipv4.inet_peer_minttl = 120
net.ipv4.inet_peer_maxttl = 600
net.ipv4.inet_peer_gc_mintime = 10
net.ipv4.inet_peer_gc_maxtime = 120
net.ipv4.tcp_orphan_retries = 0
net.ipv4.tcp_fack = 1
net.ipv4.tcp_reordering = 5
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_mem = 8388608      8388608 8388608
net.ipv4.tcp_wmem = 4096        1048576 8388608
net.ipv4.tcp_rmem = 4096        1048576 8388608
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.icmp_ratelimit = 100
net.ipv4.icmp_ratemask = 6168
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_frto = 0
net.ipv4.tcp_frto_response = 0
net.ipv4.tcp_low_latency = 0
net.ipv4.ipfrag_secret_interval = 600
net.ipv4.ipfrag_max_dist = 64
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_tso_win_divisor = 3
net.ipv4.tcp_congestion_control = cubic
net.ipv4.tcp_abc = 0
net.ipv4.tcp_mtu_probing = 0
net.ipv4.tcp_base_mss = 512
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.tcp_slow_start_after_idle = 1
net.ipv4.tcp_available_congestion_control = cubic reno
net.ipv4.tcp_allowed_congestion_control = cubic reno
net.ipv4.tcp_max_ssthresh = 0


I am not sure if I should increase rmem further or not

Thank you
Ilya
