Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128Ab0ALKkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0ALKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040Ab0ALKkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:40:35 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:46628 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0ALKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:40:35 -0500
Message-ID: <4B4C519E.2090207@gmail.com>
Date: Tue, 12 Jan 2010 11:40:30 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com>
In-Reply-To: <4B450065.4010108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 11:40:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/01/2010 22:28, William Allen Simpson a écrit :
> Redefine two TCP header functions to accept TCP header pointer.
> When subtracting, return signed int to allow error checking.
> 
> These functions will be used in subsequent patches that implement
> additional features.
> 
> Signed-off-by: William.Allen.Simpson@gmail.com
> ---
>  include/linux/tcp.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 

Its better to inline your patches so that we can comment them, without copy/paste

When I hit 'reply to', my mailer only quoted the ChangeLog, not the patch.

Anyway ..

+/* Length of standard options only.  This could be negative. */
+static inline int tcp_option_len_th(const struct tcphdr *th)
+{
+	return (int)(th->doff * 4) - sizeof(*th);
+}


The (int) cast is not necessary, since the function returns a signed int

->
	return th->doff * 4 - sizeof(*th);
