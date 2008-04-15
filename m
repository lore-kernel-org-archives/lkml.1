Return-Path: <linux-kernel-owner+w=401wt.eu-S1764382AbYDONpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764382AbYDONpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbYDONoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:44:55 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31692 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYDONoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:44:55 -0400
From: Vitaliy Gusev <vgusev@openvz.org>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
Date: Tue, 15 Apr 2008 17:47:19 +0400
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <87mynvtuoj.fsf@basil.nowhere.org> <480467AA.2050808@firstfloor.org> <20080415115924.GA1550@ms2.inr.ac.ru>
In-Reply-To: <20080415115924.GA1550@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804151747.20148.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2008 15:59:24 Alexey Kuznetsov wrote:
> Hello!
> 
> > I still think the guards are pretty much the same as before, sorry:)
> 
> Guards inside tcp_prune_queue() are the same exactly.
> 
> But the patch adds the second point where out-of-order queue is discarded.
> It is when the socket is under rcvbuf, but nevertheless skb cannot
> be queued due to system-wide limit. In that case out-of-order queue 
> is dropped and the limits are rechecked.
> 
> 
> > But why not repeat the whole prune for all cases in this case then?
> 
> Collapsing and tuning rcv_ssthresh was done once, they are not guarded
> by rcvbuf check. So, repeating those steps would be useless.
> 
> The only thing is:
> 
> > e.g. you should probably at least repeat the third step (setting
> > pred_flags to 0) too.
> 
> Formally, this is correct. But this is not necessary, pred_flags reset
> is redundant even in the first place. The fast path is not so fast,
> memory limit is checked explicitly there.
> 
> 
> The patch is not perfect. F.e. tcp_prune_ofo_queue() could see empty
> out-of-order queue, in this case the second sk_stream_rmem_schedule()
> is useless and could be skipped. But it is the second order effect.
> 
> I think this will work.

Thanks for comments. I will correct second call sk_stream_rmem_schedule()
and resend new patch.
 



-- 
Thank,
Vitaliy Gusev
