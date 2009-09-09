Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZIIQe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZIIQe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZIIQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:34:26 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:54283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbZIIQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:34:25 -0400
Date: Wed, 9 Sep 2009 12:33:21 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090905071052.50501826@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Sep 2009, Jeff Layton wrote:

> It looks like it's just taking 5s for the server to respond here. Do
> you happen to have a wire capture of one of these events? That may tell
> us more than cifsFYI info...

I did a tcpdump and nothing stands out. Server acks the "cmd 50" and then
waits 5 seconds before sending the data.

16:23:34.336373 IP (tos 0x0, ttl  64, id 20616, offset 0, flags [DF], proto 6, length: 118) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 2801206064:2801206142(78) ack 468207120 win 190
16:23:34.336624 IP (tos 0x0, ttl 125, id 19869, offset 0, flags [DF], proto 6, length: 206) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 1:167(166) ack 78 win 64548
16:23:34.336636 IP (tos 0x0, ttl  64, id 20617, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 78:78(0) ack 167 win 190
16:23:34.336669 IP (tos 0x0, ttl  64, id 20618, offset 0, flags [DF], proto 6, length: 128) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 78:166(88) ack 167 win 190
16:23:34.456343 IP (tos 0x0, ttl 125, id 20045, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 167:167(0) ack 166 win 64460

hiccup

16:23:39.284930 IP (tos 0x0, ttl 125, id 27544, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 167:357(190) ack 166 win 64460
16:23:39.324060 IP (tos 0x0, ttl  64, id 20619, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 357 win 190
16:23:39.324292 IP (tos 0x0, ttl 125, id 27563, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 357:1817(1460) ack 166 win 64460
16:23:39.324300 IP (tos 0x0, ttl  64, id 20620, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 1817 win 190
16:23:39.324306 IP (tos 0x0, ttl 125, id 27564, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 1817:3277(1460) ack 166 win 64460
16:23:39.324311 IP (tos 0x0, ttl  64, id 20621, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 3277 win 188
16:23:39.324315 IP (tos 0x0, ttl 125, id 27565, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 3277:4737(1460) ack 166 win 64460
16:23:39.324319 IP (tos 0x0, ttl  64, id 20622, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 4737 win 186
16:23:39.324321 IP (tos 0x0, ttl 125, id 27566, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 4737:6197(1460) ack 166 win 64460
16:23:39.324324 IP (tos 0x0, ttl  64, id 20623, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 6197 win 184
16:23:39.324329 IP (tos 0x0, ttl 125, id 27567, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 6197:7657(1460) ack 166 win 64460
16:23:39.324332 IP (tos 0x0, ttl  64, id 20624, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 7657 win 182
16:23:39.324335 IP (tos 0x0, ttl 125, id 27568, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 7657:9117(1460) ack 166 win 64460
16:23:39.324337 IP (tos 0x0, ttl  64, id 20625, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 9117 win 180
16:23:39.324354 IP (tos 0x0, ttl 125, id 27569, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 9117:10577(1460) ack 166 win 64460
16:23:39.324362 IP (tos 0x0, ttl  64, id 20626, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 10577 win 190
16:23:39.324371 IP (tos 0x0, ttl 125, id 27570, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 10577:12037(1460) ack 166 win 64460
16:23:39.324374 IP (tos 0x0, ttl  64, id 20627, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 12037 win 188
16:23:39.324377 IP (tos 0x0, ttl 125, id 27571, offset 0, flags [DF], proto 6, length: 1500) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 12037:13497(1460) ack 166 win 64460
16:23:39.324379 IP (tos 0x0, ttl  64, id 20628, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 13497 win 186
16:23:39.324383 IP (tos 0x0, ttl 125, id 27572, offset 0, flags [DF], proto 6, length: 502) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 13497:13959(462) ack 166 win 64460
16:23:39.324385 IP (tos 0x0, ttl  64, id 20629, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 13959 win 186
16:23:39.324666 IP (tos 0x0, ttl  64, id 20630, offset 0, flags [DF], proto 6, length: 150) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 166:276(110) ack 13959 win 190
16:23:39.486091 IP (tos 0x0, ttl 125, id 28080, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 13959:13959(0) ack 276 win 64350

hiccup

16:23:44.315476 IP (tos 0x0, ttl 125, id 2862, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 13959:14149(190) ack 276 win 64350
16:23:44.355370 IP (tos 0x0, ttl  64, id 20631, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 276:276(0) ack 14149 win 190
16:23:44.355531 IP (tos 0x0, ttl 125, id 2875, offset 0, flags [DF], proto 6, length: 48) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 14149:14157(8) ack 276 win 64350
16:23:44.355540 IP (tos 0x0, ttl  64, id 20632, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 276:276(0) ack 14157 win 190
16:23:44.355765 IP (tos 0x0, ttl  64, id 20633, offset 0, flags [DF], proto 6, length: 178) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 276:414(138) ack 14157 win 190
16:23:44.517419 IP (tos 0x0, ttl 125, id 3277, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 14157:14157(0) ack 414 win 64212

hiccup

16:23:49.245126 IP (tos 0x0, ttl 125, id 10924, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 14157:14347(190) ack 414 win 64212
16:23:49.285309 IP (tos 0x0, ttl  64, id 20634, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 414:414(0) ack 14347 win 190
16:23:49.285462 IP (tos 0x0, ttl 125, id 11044, offset 0, flags [DF], proto 6, length: 76) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 14347:14383(36) ack 414 win 64212
16:23:49.285470 IP (tos 0x0, ttl  64, id 20635, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 414:414(0) ack 14383 win 190
16:23:49.285505 IP (tos 0x0, ttl  64, id 20636, offset 0, flags [DF], proto 6, length: 184) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 414:558(144) ack 14383 win 190
16:23:49.447170 IP (tos 0x0, ttl 125, id 11093, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 14383:14383(0) ack 558 win 65535

hiccup

16:23:54.275481 IP (tos 0x0, ttl 125, id 18653, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 14383:14573(190) ack 558 win 65535
16:23:54.315247 IP (tos 0x0, ttl  64, id 20637, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 558:558(0) ack 14573 win 190
16:23:54.315383 IP (tos 0x0, ttl 125, id 18719, offset 0, flags [DF], proto 6, length: 82) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 14573:14615(42) ack 558 win 65535
16:23:54.315392 IP (tos 0x0, ttl  64, id 20638, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 558:558(0) ack 14615 win 190
16:23:54.315443 IP (tos 0x0, ttl  64, id 20639, offset 0, flags [DF], proto 6, length: 158) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 558:676(118) ack 14615 win 190
16:23:54.477564 IP (tos 0x0, ttl 125, id 19062, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 14615:14615(0) ack 676 win 65417

hiccup
and so on.

16:23:59.306748 IP (tos 0x0, ttl 125, id 27953, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 14615:14805(190) ack 676 win 65417
16:23:59.346120 IP (tos 0x0, ttl  64, id 20640, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 676:676(0) ack 14805 win 190
16:23:59.346256 IP (tos 0x0, ttl 125, id 27964, offset 0, flags [DF], proto 6, length: 56) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 14805:14821(16) ack 676 win 65417
16:23:59.346264 IP (tos 0x0, ttl  64, id 20641, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 676:676(0) ack 14821 win 190
16:23:59.346293 IP (tos 0x0, ttl  64, id 20642, offset 0, flags [DF], proto 6, length: 156) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 676:792(116) ack 14821 win 190
16:23:59.507011 IP (tos 0x0, ttl 125, id 28189, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 14821:14821(0) ack 792 win 65301
16:24:04.336231 IP (tos 0x0, ttl 125, id 22093, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 14821:15011(190) ack 792 win 65301
16:24:04.375997 IP (tos 0x0, ttl  64, id 20643, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 792:792(0) ack 15011 win 190
16:24:04.376163 IP (tos 0x0, ttl 125, id 22565, offset 0, flags [DF], proto 6, length: 54) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 15011:15025(14) ack 792 win 65301
16:24:04.376170 IP (tos 0x0, ttl  64, id 20644, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 792:792(0) ack 15025 win 190
16:24:04.376223 IP (tos 0x0, ttl  64, id 20645, offset 0, flags [DF], proto 6, length: 190) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 792:942(150) ack 15025 win 190
16:24:04.538328 IP (tos 0x0, ttl 125, id 23320, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 15025:15025(0) ack 942 win 65151
16:24:09.266915 IP (tos 0x0, ttl 125, id 31959, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 15025:15215(190) ack 942 win 65151
16:24:09.306308 IP (tos 0x0, ttl  64, id 20646, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 942:942(0) ack 15215 win 190
16:24:09.306608 IP (tos 0x0, ttl 125, id 31990, offset 0, flags [DF], proto 6, length: 88) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 15215:15263(48) ack 942 win 65151
16:24:09.306614 IP (tos 0x0, ttl  64, id 20647, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 942:942(0) ack 15263 win 190
16:24:09.306640 IP (tos 0x0, ttl  64, id 20648, offset 0, flags [DF], proto 6, length: 198) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 942:1100(158) ack 15263 win 190
16:24:09.467203 IP (tos 0x0, ttl 125, id 32472, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 15263:15263(0) ack 1100 win 64993
16:24:14.296632 IP (tos 0x0, ttl 125, id 5658, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 15263:15453(190) ack 1100 win 64993
16:24:14.336194 IP (tos 0x0, ttl  64, id 20649, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1100:1100(0) ack 15453 win 190
16:24:14.336334 IP (tos 0x0, ttl 125, id 5674, offset 0, flags [DF], proto 6, length: 96) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 15453:15509(56) ack 1100 win 64993
16:24:14.336343 IP (tos 0x0, ttl  64, id 20650, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1100:1100(0) ack 15509 win 190
16:24:14.336371 IP (tos 0x0, ttl  64, id 20651, offset 0, flags [DF], proto 6, length: 152) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 1100:1212(112) ack 15509 win 190
16:24:14.498506 IP (tos 0x0, ttl 125, id 5736, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 15509:15509(0) ack 1212 win 64881
16:24:19.327717 IP (tos 0x0, ttl 125, id 15788, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 15509:15699(190) ack 1212 win 64881
16:24:19.367433 IP (tos 0x0, ttl  64, id 20652, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1212:1212(0) ack 15699 win 190
16:24:19.367575 IP (tos 0x0, ttl 125, id 15806, offset 0, flags [DF], proto 6, length: 50) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 15699:15709(10) ack 1212 win 64881
16:24:19.367582 IP (tos 0x0, ttl  64, id 20653, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1212:1212(0) ack 15709 win 190
16:24:19.367609 IP (tos 0x0, ttl  64, id 20654, offset 0, flags [DF], proto 6, length: 154) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 1212:1326(114) ack 15709 win 190
16:24:19.528913 IP (tos 0x0, ttl 125, id 15988, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 15709:15709(0) ack 1326 win 64767
16:24:24.256535 IP (tos 0x0, ttl 125, id 23005, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 15709:15899(190) ack 1326 win 64767
16:24:24.296246 IP (tos 0x0, ttl  64, id 20655, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1326:1326(0) ack 15899 win 190
16:24:24.296397 IP (tos 0x0, ttl 125, id 23025, offset 0, flags [DF], proto 6, length: 52) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 15899:15911(12) ack 1326 win 64767
16:24:24.296406 IP (tos 0x0, ttl  64, id 20656, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1326:1326(0) ack 15911 win 190
16:24:24.296477 IP (tos 0x0, ttl  64, id 20657, offset 0, flags [DF], proto 6, length: 144) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 1326:1430(104) ack 15911 win 190
16:24:24.457828 IP (tos 0x0, ttl 125, id 23198, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 15911:15911(0) ack 1430 win 64663
16:24:29.286968 IP (tos 0x0, ttl 125, id 4906, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 15911:16101(190) ack 1430 win 64663
16:24:29.326433 IP (tos 0x0, ttl  64, id 20658, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1430:1430(0) ack 16101 win 190
16:24:29.326569 IP (tos 0x0, ttl 125, id 4947, offset 0, flags [DF], proto 6, length: 42) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 16101:16103(2) ack 1430 win 64663
16:24:29.326576 IP (tos 0x0, ttl  64, id 20659, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1430:1430(0) ack 16103 win 190
16:24:29.326605 IP (tos 0x0, ttl  64, id 20660, offset 0, flags [DF], proto 6, length: 144) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 1430:1534(104) ack 16103 win 190
16:24:29.489040 IP (tos 0x0, ttl 125, id 5027, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 16103:16103(0) ack 1534 win 64559
16:24:34.318242 IP (tos 0x0, ttl 125, id 19964, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 16103:16293(190) ack 1534 win 64559
16:24:34.357998 IP (tos 0x0, ttl  64, id 20661, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1534:1534(0) ack 16293 win 190
16:24:34.358139 IP (tos 0x0, ttl 125, id 19965, offset 0, flags [DF], proto 6, length: 42) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P [tcp sum ok] 16293:16295(2) ack 1534 win 64559
16:24:34.358167 IP (tos 0x0, ttl  64, id 20662, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 1534:1534(0) ack 16295 win 190
16:24:34.358204 IP (tos 0x0, ttl  64, id 20663, offset 0, flags [DF], proto 6, length: 140) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 1534:1634(100) ack 16295 win 190
16:24:34.358464 IP (tos 0x0, ttl 125, id 19966, offset 0, flags [DF], proto 6, length: 228) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 16295:16483(188) ack 1634 win 64459
16:24:34.358496 IP (tos 0x0, ttl  64, id 20664,
