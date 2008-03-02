Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYCBNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYCBNPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 08:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYCBNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 08:15:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:51832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYCBNPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 08:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I2n2mLbRvFWJVXJsLi3ipYxyjMSUy+YKhVmHeWrOwibWY1IEQFtbmi2POBqRfmYEj+unoAtMAiQv5IabNe2Xoyz4vFJyyKzKpxVRcYpBvcRhIjyz79cIfDHgHMXPRITE8Iys4KjBsai6ORaLn9KsNXtNIh1kRvg+K8tP0/8jcAE=
Message-ID: <3d8471ca0803020515m1e4af9d9xd37a8912e58a4504@mail.gmail.com>
Date: Sun, 2 Mar 2008 14:15:01 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
Cc: "Giangiacomo Mariotti" <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803021432200.17919@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <858077.97160.qm@web39709.mail.mud.yahoo.com>
	 <20080223000310.4630daa8.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi>
	 <3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
	 <Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi>
	 <Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
	 <3d8471ca0803020420ka42319bu1b9888217c869d9d@mail.gmail.com>
	 <Pine.LNX.4.64.0803021432200.17919@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m22DG8nq031152

On Sun, Mar 2, 2008 at 1:38 PM, Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi> wrote:>  In future, please inline at least the first one of them, if not sure>  where to cut, too much won't hurt... :-)
OK, will do.
>  > It does not contain any "KERNEL: assertion (packets <=>  > tp->packets_out) failed at" line, so I'm afraid it's just noise.>>  At least it catches one bug which could cause that assertion (it is much>  more rigid than the assertion and thus it catched it even though you>  won't see that assertion to ever trigger :-)).
Great :-)
>  Could you next figure out what is at:>   [<c02e0f83>] tcp_ack+0x621/0xd2f
tcp_clean_rtx_queue() is automatically inlined into tcp_ack() by gcc.
That's:
tcp_ack():        /* See if we can take anything off of the retransmit queue. */        flag |= tcp_clean_rtx_queue(sk, prior_fackets);
tcp_clean_rtx_queue():        tcp_verify_left_out(tp);    <=========== Here
        if (skb && (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))                flag |= FLAG_SACK_RENEGING;

Thanks.
-- Guillaumeÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
