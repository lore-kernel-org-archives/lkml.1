Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbXHURol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbXHURol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbXHURo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:44:29 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:59738 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760218AbXHURo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:44:27 -0400
Date: Tue, 21 Aug 2007 13:44:24 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821174424.GB8360@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070821173849.GA8360@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:39:02 up 22 days, 17:57,  4 users,  load average: 0.63, 0.43, 0.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

If you are interested in the raw numbers:

The (very basic) test module follows. Make sure you change get_cycles()
for get_cycles_sync() if you plan to run this on x86_64.

(tests taken on a 3GHz Pentium 4)

* slub HEAD, test 1

[   99.774699] SLUB Performance testing
[   99.785431] ========================
[   99.796099] 1. Kmalloc: Repeatedly allocate then free test
[   99.813159] 10000 times kmalloc(8) = 
[   99.824072] number of loops: 10000
[   99.834207] total time: 2019990
[   99.843562] -> 201 cycles
[   99.852535] 10000 times kfree = 
[   99.862167] number of loops: 10000
[   99.872310] total time: 3519982
[   99.881669] -> 351 cycles
[   99.890128] 10000 times kmalloc(16) = 
[   99.901298] number of loops: 10000
[   99.911433] total time: 1986503
[   99.920786] -> 198 cycles
[   99.929784] 10000 times kfree = 
[   99.939397] number of loops: 10000
[   99.949532] total time: 3596775
[   99.958885] -> 359 cycles
[   99.967352] 10000 times kmalloc(32) = 
[   99.978522] number of loops: 10000
[   99.988657] total time: 2009003
[   99.998098] -> 200 cycles
[  100.007171] 10000 times kfree = 
[  100.016786] number of loops: 10000
[  100.026919] total time: 3814418
[  100.036296] -> 381 cycles
[  100.044844] 10000 times kmalloc(64) = 
[  100.056016] number of loops: 10000
[  100.066150] total time: 2242620
[  100.075504] -> 224 cycles
[  100.084619] 10000 times kfree = 
[  100.094234] number of loops: 10000
[  100.104369] total time: 3941348
[  100.113722] -> 394 cycles
[  100.122475] 10000 times kmalloc(128) = 
[  100.133914] number of loops: 10000
[  100.144049] total time: 2857560
[  100.153485] -> 285 cycles
[  100.162705] 10000 times kfree = 
[  100.172332] number of loops: 10000
[  100.182468] total time: 4241543
[  100.191821] -> 424 cycles
[  100.200996] 10000 times kmalloc(256) = 
[  100.212437] number of loops: 10000
[  100.222571] total time: 4119900
[  100.231949] -> 411 cycles
[  100.241570] 10000 times kfree = 
[  100.251218] number of loops: 10000
[  100.261353] total time: 5462655
[  100.270705] -> 546 cycles
[  100.280105] 10000 times kmalloc(512) = 
[  100.291548] number of loops: 10000
[  100.301683] total time: 4802820
[  100.311037] -> 480 cycles
[  100.320899] 10000 times kfree = 
[  100.330518] number of loops: 10000
[  100.340661] total time: 6191827
[  100.350040] -> 619 cycles
[  100.359917] 10000 times kmalloc(1024) = 
[  100.371633] number of loops: 10000
[  100.381767] total time: 6235890
[  100.391120] -> 623 cycles
[  100.401419] 10000 times kfree = 
[  100.411034] number of loops: 10000
[  100.421170] total time: 7504095
[  100.430523] -> 750 cycles
[  100.440608] 10000 times kmalloc(2048) = 
[  100.452300] number of loops: 10000
[  100.462433] total time: 6863955
[  100.471786] -> 686 cycles
[  100.482287] 10000 times kfree = 
[  100.491922] number of loops: 10000
[  100.502065] total time: 8110590
[  100.511419] -> 811 cycles
[  100.520824] 10000 times kmalloc(4096) = 
[  100.532537] number of loops: 10000
[  100.542670] total time: 4824007
[  100.552023] -> 482 cycles
[  100.561618] 10000 times kfree = 
[  100.571255] number of loops: 10000
[  100.581390] total time: 5387670
[  100.590768] -> 538 cycles
[  100.600835] 10000 times kmalloc(8192) = 
[  100.612549] number of loops: 10000
[  100.622684] total time: 6808680
[  100.632037] -> 680 cycles
[  100.642285] 10000 times kfree = 
[  100.651898] number of loops: 10000
[  100.662031] total time: 7349797
[  100.671385] -> 734 cycles
[  100.681563] 10000 times kmalloc(16384) = 
[  100.693523] number of loops: 10000
[  100.703658] total time: 7133790
[  100.713036] -> 713 cycles
[  100.723654] 10000 times kfree = 
[  100.733299] number of loops: 10000
[  100.743434] total time: 8431725
[  100.752788] -> 843 cycles
[  100.760588] 2. Kmalloc: alloc/free test
[  100.773091] 10000 times kmalloc(8)/kfree = 
[  100.785558] number of loops: 10000
[  100.795694] total time: 3223072
[  100.805046] -> 322 cycles
[  100.813904] 10000 times kmalloc(16)/kfree = 
[  100.826629] number of loops: 10000
[  100.836763] total time: 3181702
[  100.846116] -> 318 cycles
[  100.854975] 10000 times kmalloc(32)/kfree = 
[  100.867725] number of loops: 10000
[  100.877860] total time: 3183517
[  100.887296] -> 318 cycles
[  100.896179] 10000 times kmalloc(64)/kfree = 
[  100.908905] number of loops: 10000
[  100.919039] total time: 3253335
[  100.928418] -> 325 cycles
[  100.937277] 10000 times kmalloc(128)/kfree = 
[  100.950272] number of loops: 10000
[  100.960407] total time: 3181478
[  100.969760] -> 318 cycles
[  100.978652] 10000 times kmalloc(256)/kfree = 
[  100.991662] number of loops: 10000
[  101.001796] total time: 3282810
[  101.011149] -> 328 cycles
[  101.020042] 10000 times kmalloc(512)/kfree = 
[  101.033025] number of loops: 10000
[  101.043161] total time: 3286725
[  101.052515] -> 328 cycles
[  101.061409] 10000 times kmalloc(1024)/kfree = 
[  101.074652] number of loops: 10000
[  101.084787] total time: 3281677
[  101.094141] -> 328 cycles
[  101.103033] 10000 times kmalloc(2048)/kfree = 
[  101.116277] number of loops: 10000
[  101.126413] total time: 3281460
[  101.135789] -> 328 cycles
[  101.145850] 10000 times kmalloc(4096)/kfree = 
[  101.159120] number of loops: 10000
[  101.169255] total time: 6786870
[  101.178608] -> 678 cycles
[  101.189783] 10000 times kmalloc(8192)/kfree = 
[  101.203030] number of loops: 10000
[  101.213166] total time: 10135372
[  101.222846] -> 1013 cycles
[  101.234812] 10000 times kmalloc(16384)/kfree = 
[  101.248342] number of loops: 10000
[  101.258476] total time: 11575222
[  101.268090] -> 1157 cycles


* Slub HEAD, test 2

[  225.212707] SLUB Performance testing
[  225.223363] ========================
[  225.234040] 1. Kmalloc: Repeatedly allocate then free test
[  225.251038] 10000 times kmalloc(8) = 
[  225.261956] number of loops: 10000
[  225.272089] total time: 1908952
[  225.281444] -> 190 cycles
[  225.290415] 10000 times kfree = 
[  225.300028] number of loops: 10000
[  225.310164] total time: 3516172
[  225.319527] -> 351 cycles
[  225.327979] 10000 times kmalloc(16) = 
[  225.339174] number of loops: 10000
[  225.349309] total time: 1955085
[  225.358661] -> 195 cycles
[  225.367662] 10000 times kfree = 
[  225.377275] number of loops: 10000
[  225.387411] total time: 3602730
[  225.396789] -> 360 cycles
[  225.405258] 10000 times kmalloc(32) = 
[  225.416426] number of loops: 10000
[  225.426561] total time: 2010450
[  225.435914] -> 201 cycles
[  225.444949] 10000 times kfree = 
[  225.454631] number of loops: 10000
[  225.464829] total time: 3706695
[  225.474239] -> 370 cycles
[  225.482926] 10000 times kmalloc(64) = 
[  225.494100] number of loops: 10000
[  225.504236] total time: 2450453
[  225.513590] -> 245 cycles
[  225.522689] 10000 times kfree = 
[  225.532303] number of loops: 10000
[  225.542443] total time: 3897607
[  225.551798] -> 389 cycles
[  225.560546] 10000 times kmalloc(128) = 
[  225.571987] number of loops: 10000
[  225.582122] total time: 2837782
[  225.591475] -> 283 cycles
[  225.600653] 10000 times kfree = 
[  225.610277] number of loops: 10000
[  225.620412] total time: 4130122
[  225.629789] -> 413 cycles
[  225.638956] 10000 times kmalloc(256) = 
[  225.650398] number of loops: 10000
[  225.660534] total time: 4093110
[  225.669887] -> 409 cycles
[  225.679515] 10000 times kfree = 
[  225.689135] number of loops: 10000
[  225.699269] total time: 5478518
[  225.708633] -> 547 cycles
[  225.718031] 10000 times kmalloc(512) = 
[  225.729468] number of loops: 10000
[  225.739602] total time: 4765365
[  225.748955] -> 476 cycles
[  225.758810] 10000 times kfree = 
[  225.768431] number of loops: 10000
[  225.778565] total time: 6167265
[  225.787918] -> 616 cycles
[  225.797811] 10000 times kmalloc(1024) = 
[  225.809504] number of loops: 10000
[  225.819639] total time: 6280335
[  225.828991] -> 628 cycles
[  225.839302] 10000 times kfree = 
[  225.848942] number of loops: 10000
[  225.859078] total time: 7538393
[  225.868456] -> 753 cycles
[  225.878535] 10000 times kmalloc(2048) = 
[  225.890226] number of loops: 10000
[  225.900362] total time: 6842648
[  225.909716] -> 684 cycles
[  225.920218] 10000 times kfree = 
[  225.929834] number of loops: 10000
[  225.939977] total time: 8114550
[  225.949331] -> 811 cycles
[  225.958730] 10000 times kmalloc(4096) = 
[  225.970419] number of loops: 10000
[  225.980554] total time: 4803345
[  225.989933] -> 480 cycles
[  225.999531] 10000 times kfree = 
[  226.009145] number of loops: 10000
[  226.019278] total time: 5398282
[  226.028656] -> 539 cycles
[  226.038659] 10000 times kmalloc(8192) = 
[  226.050349] number of loops: 10000
[  226.060484] total time: 6613185
[  226.069837] -> 661 cycles
[  226.080124] 10000 times kfree = 
[  226.089738] number of loops: 10000
[  226.099874] total time: 7467765
[  226.109251] -> 746 cycles
[  226.119523] 10000 times kmalloc(16384) = 
[  226.131476] number of loops: 10000
[  226.141611] total time: 7417830
[  226.150963] -> 741 cycles
[  226.161627] 10000 times kfree = 
[  226.171250] number of loops: 10000
[  226.181386] total time: 8564873
[  226.190765] -> 856 cycles
[  226.198565] 2. Kmalloc: alloc/free test
[  226.211071] 10000 times kmalloc(8)/kfree = 
[  226.223538] number of loops: 10000
[  226.233674] total time: 3233355
[  226.243028] -> 323 cycles
[  226.251887] 10000 times kmalloc(16)/kfree = 
[  226.264612] number of loops: 10000
[  226.274755] total time: 3181650
[  226.284132] -> 318 cycles
[  226.292991] 10000 times kmalloc(32)/kfree = 
[  226.305716] number of loops: 10000
[  226.315851] total time: 3181140
[  226.325228] -> 318 cycles
[  226.334089] 10000 times kmalloc(64)/kfree = 
[  226.346839] number of loops: 10000
[  226.356974] total time: 3183255
[  226.366352] -> 318 cycles
[  226.375216] 10000 times kmalloc(128)/kfree = 
[  226.388210] number of loops: 10000
[  226.398345] total time: 3188498
[  226.407698] -> 318 cycles
[  226.416591] 10000 times kmalloc(256)/kfree = 
[  226.429602] number of loops: 10000
[  226.439737] total time: 3281130
[  226.449090] -> 328 cycles
[  226.457983] 10000 times kmalloc(512)/kfree = 
[  226.470992] number of loops: 10000
[  226.481127] total time: 3283387
[  226.490480] -> 328 cycles
[  226.499375] 10000 times kmalloc(1024)/kfree = 
[  226.512619] number of loops: 10000
[  226.522754] total time: 3287888
[  226.532106] -> 328 cycles
[  226.540999] 10000 times kmalloc(2048)/kfree = 
[  226.554270] number of loops: 10000
[  226.564405] total time: 3281467
[  226.573757] -> 328 cycles
[  226.583720] 10000 times kmalloc(4096)/kfree = 
[  226.596989] number of loops: 10000
[  226.607124] total time: 6489922
[  226.616476] -> 648 cycles
[  226.627646] 10000 times kmalloc(8192)/kfree = 
[  226.640891] number of loops: 10000
[  226.651027] total time: 10095772
[  226.660639] -> 1009 cycles
[  226.672381] 10000 times kmalloc(16384)/kfree = 
[  226.685910] number of loops: 10000
[  226.696045] total time: 11056943
[  226.705658] -> 1105 cycles

* cmpxchg_local Slub test

[  119.518080] SLUB Performance testing
[  119.528739] ========================
[  119.539393] 1. Kmalloc: Repeatedly allocate then free test
[  119.556032] 10000 times kmalloc(8) = 
[  119.566952] number of loops: 10000
[  119.577087] total time: 831930
[  119.586182] -> 83 cycles
[  119.594933] 10000 times kfree = 
[  119.604570] number of loops: 10000
[  119.614705] total time: 3636653
[  119.624059] -> 363 cycles
[  119.632142] 10000 times kmalloc(16) = 
[  119.643330] number of loops: 10000
[  119.653464] total time: 851895
[  119.662564] -> 85 cycles
[  119.671341] 10000 times kfree = 
[  119.680954] number of loops: 10000
[  119.691089] total time: 3722985
[  119.700441] -> 372 cycles
[  119.708551] 10000 times kmalloc(32) = 
[  119.719721] number of loops: 10000
[  119.729855] total time: 928470
[  119.738973] -> 92 cycles
[  119.747770] 10000 times kfree = 
[  119.757382] number of loops: 10000
[  119.767518] total time: 3772147
[  119.776871] -> 377 cycles
[  119.785065] 10000 times kmalloc(64) = 
[  119.796246] number of loops: 10000
[  119.806380] total time: 1157535
[  119.815734] -> 115 cycles
[  119.824858] 10000 times kfree = 
[  119.834473] number of loops: 10000
[  119.844609] total time: 3975780
[  119.853962] -> 397 cycles
[  119.862361] 10000 times kmalloc(128) = 
[  119.873801] number of loops: 10000
[  119.883940] total time: 1792695
[  119.893382] -> 179 cycles
[  119.902658] 10000 times kfree = 
[  119.912282] number of loops: 10000
[  119.922416] total time: 4385093
[  119.931769] -> 438 cycles
[  119.940617] 10000 times kmalloc(256) = 
[  119.952146] number of loops: 10000
[  119.962345] total time: 3140227
[  119.971753] -> 314 cycles
[  119.981498] 10000 times kfree = 
[  119.991124] number of loops: 10000
[  120.001258] total time: 5641035
[  120.010613] -> 564 cycles
[  120.019752] 10000 times kmalloc(512) = 
[  120.031186] number of loops: 10000
[  120.041321] total time: 3989085
[  120.050676] -> 398 cycles
[  120.060528] 10000 times kfree = 
[  120.070146] number of loops: 10000
[  120.080281] total time: 6159315
[  120.089633] -> 615 cycles
[  120.099344] 10000 times kmalloc(1024) = 
[  120.111033] number of loops: 10000
[  120.121168] total time: 5733525
[  120.130546] -> 573 cycles
[  120.140827] 10000 times kfree = 
[  120.150444] number of loops: 10000
[  120.160579] total time: 7450170
[  120.169956] -> 745 cycles
[  120.179854] 10000 times kmalloc(2048) = 
[  120.191544] number of loops: 10000
[  120.201680] total time: 6298380
[  120.211033] -> 629 cycles
[  120.221555] 10000 times kfree = 
[  120.231170] number of loops: 10000
[  120.241305] total time: 8169892
[  120.250666] -> 816 cycles
[  120.260044] 10000 times kmalloc(4096) = 
[  120.271733] number of loops: 10000
[  120.281868] total time: 4739040
[  120.291221] -> 473 cycles
[  120.300847] 10000 times kfree = 
[  120.310483] number of loops: 10000
[  120.320619] total time: 5484870
[  120.329973] -> 548 cycles
[  120.339970] 10000 times kmalloc(8192) = 
[  120.351659] number of loops: 10000
[  120.361805] total time: 6594803
[  120.371184] -> 659 cycles
[  120.381465] 10000 times kfree = 
[  120.391104] number of loops: 10000
[  120.401240] total time: 7454415
[  120.410618] -> 745 cycles
[  120.420834] 10000 times kmalloc(16384) = 
[  120.432797] number of loops: 10000
[  120.442932] total time: 7245863
[  120.452311] -> 724 cycles
[  120.462923] 10000 times kfree = 
[  120.472545] number of loops: 10000
[  120.482689] total time: 8431665
[  120.492043] -> 843 cycles
[  120.499843] 2. Kmalloc: alloc/free test
[  120.511647] 10000 times kmalloc(8)/kfree = 
[  120.524116] number of loops: 10000
[  120.534251] total time: 1129178
[  120.543629] -> 112 cycles
[  120.551773] 10000 times kmalloc(16)/kfree = 
[  120.564524] number of loops: 10000
[  120.574658] total time: 1036778
[  120.584036] -> 103 cycles
[  120.592180] 10000 times kmalloc(32)/kfree = 
[  120.604905] number of loops: 10000
[  120.615040] total time: 1031220
[  120.624419] -> 103 cycles
[  120.632561] 10000 times kmalloc(64)/kfree = 
[  120.645289] number of loops: 10000
[  120.655425] total time: 1031025
[  120.664777] -> 103 cycles
[  120.672954] 10000 times kmalloc(128)/kfree = 
[  120.685941] number of loops: 10000
[  120.696075] total time: 1127857
[  120.705429] -> 112 cycles
[  120.713599] 10000 times kmalloc(256)/kfree = 
[  120.726591] number of loops: 10000
[  120.736724] total time: 1110885
[  120.746101] -> 111 cycles
[  120.754271] 10000 times kmalloc(512)/kfree = 
[  120.767256] number of loops: 10000
[  120.777392] total time: 1110855
[  120.786770] -> 111 cycles
[  120.794940] 10000 times kmalloc(1024)/kfree = 
[  120.808239] number of loops: 10000
[  120.818373] total time: 1111522
[  120.827729] -> 111 cycles
[  120.835932] 10000 times kmalloc(2048)/kfree = 
[  120.849175] number of loops: 10000
[  120.859311] total time: 1217235
[  120.868664] -> 121 cycles
[  120.878627] 10000 times kmalloc(4096)/kfree = 
[  120.891872] number of loops: 10000
[  120.902006] total time: 6501330
[  120.911383] -> 650 cycles
[  120.922653] 10000 times kmalloc(8192)/kfree = 
[  120.935922] number of loops: 10000
[  120.946065] total time: 10424333
[  120.955677] -> 1042 cycles
[  120.967571] 10000 times kmalloc(16384)/kfree = 
[  120.981099] number of loops: 10000
[  120.991233] total time: 11495947
[  121.000871] -> 1149 cycles

* test module

Note that the kmalloc_caches is defined out because we are not a
boot-time, but at module load time and it does not work.

/* test-slub.c
 *
 * Compare local cmpxchg with irq disable / enable with cmpxchg_local for slub.
 */


#include <linux/jiffies.h>
#include <linux/compiler.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/calc64.h>
#include <asm/timex.h>
#include <asm/system.h>

#define TEST_COUNT 10000

static int slub_test_init(void)
{
	void **v = kmalloc(TEST_COUNT * sizeof(void *), GFP_KERNEL);
	unsigned int i;
	cycles_t time1, time2, time;
	long rem;
	int size;

	printk(KERN_ALERT "test init\n");

	printk(KERN_ALERT "SLUB Performance testing\n");
	printk(KERN_ALERT "========================\n");
	printk(KERN_ALERT "1. Kmalloc: Repeatedly allocate then free test\n");
	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			v[i] = kmalloc(size, GFP_KERNEL);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%i times kmalloc(%d) = \n", i, size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);

		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kfree(v[i]);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%i times kfree = \n", i);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);
	}

	printk(KERN_ALERT "2. Kmalloc: alloc/free test\n");
	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kfree(kmalloc(size, GFP_KERNEL));
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%i times kmalloc(%d)/kfree = \n", i, size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);
	}
#if 0
	printk(KERN_ALERT "3. kmem_cache_alloc: Repeatedly allocate then free test\n");
	for (size = 3; size <= PAGE_SHIFT; size ++) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			v[i] = kmem_cache_alloc(kmalloc_caches + size, GFP_KERNEL);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%d times kmem_cache_alloc(%d) = \n", i, 1 << size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);

		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kmem_cache_free(kmalloc_caches + size, v[i]);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%i times kmem_cache_free = \n", i);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);
	}

	printk(KERN_ALERT "4. kmem_cache_alloc: alloc/free test\n");
	for (size = 3; size <= PAGE_SHIFT; size++) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kmem_cache_free(kmalloc_caches + size,
				kmem_cache_alloc(kmalloc_caches + size,
							GFP_KERNEL));
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%d times kmem_cache_alloc(%d)/kmem_cache_free = \n", i, 1 << size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);
	}
	printk(KERN_ALERT "5. kmem_cache_zalloc: Repeatedly allocate then free test\n");
	for (size = 3; size <= PAGE_SHIFT; size ++) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			v[i] = kmem_cache_zalloc(kmalloc_caches + size, GFP_KERNEL);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%d times kmem_cache_zalloc(%d) = \n", i, 1 << size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);

		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kmem_cache_free(kmalloc_caches + size, v[i]);
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%i times kmem_cache_free = \n", i);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);
	}

	printk(KERN_ALERT "6. kmem_cache_zalloc: alloc/free test\n");
	for (size = 3; size <= PAGE_SHIFT; size++) {
		time1 = get_cycles();
		for (i = 0; i < TEST_COUNT; i++) {
			kmem_cache_free(kmalloc_caches + size,
				kmem_cache_zalloc(kmalloc_caches + size,
							GFP_KERNEL));
		}
		time2 = get_cycles();
		time = time2 - time1;

		printk(KERN_ALERT "%d times kmem_cache_zalloc(%d)/kmem_cache_free = \n", i, 1 << size);
		printk(KERN_ALERT "number of loops: %d\n", TEST_COUNT);
		printk(KERN_ALERT "total time: %llu\n", time);
		time = div_long_long_rem(time, TEST_COUNT, &rem);
		printk(KERN_ALERT "-> %llu cycles\n", time);

	}
#endif //0
	kfree(v);
	return -EAGAIN; /* Fail will directly unload the module */
}

static void slub_test_exit(void)
{
	printk(KERN_ALERT "test exit\n");
}

module_init(slub_test_init)
module_exit(slub_test_exit)

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mathieu Desnoyers");
MODULE_DESCRIPTION("SLUB test");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
