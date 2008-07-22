Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYGVM41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYGVM41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYGVM4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:56:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYGVM4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:56:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NV37xaZFP8rbceLse57vnQtLb6SpocgViRVKSZ3t3irXBx1qTrilEXI+Yl3jKCLAG
	2N4e6m+J0ibEWduToT2pA==
Message-ID: <6599ad830807220556i3c2afc77j2e68d7179830b3ff@mail.gmail.com>
Date: Tue, 22 Jul 2008 08:56:04 -0400
From: "Paul Menage" <menage@google.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH] Traffic control cgroups subsystem
Cc: "Ranjit Manomohan" <ranjitm@google.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, lizf@cn.fujitsu.com
In-Reply-To: <4885D72A.1060106@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807212100580.1760@ranjit.corp.google.com>
	 <4885B7DD.7070507@trash.net>
	 <6599ad830807220514m5afea0fcsb99bf2e95f401c36@mail.gmail.com>
	 <4885D72A.1060106@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 8:48 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> Using skb->priority for classification would be fine, but it would
> probably interfere with the default initialization to sk->sk_priority.

Well internally we just overloaded sk->sk_priority to be the classid,
and let skb->priority be inherited from that.

>
>> Regarding skb->sk->sk_cgroup_classid, is it always the case that the
>> original sk is still available when we're making traffic control
>> decisions? I'd thought that there were cases (e.g. cloning skbs in the
>> TCP retransmit path) where the pointer to the original sk is lost.
>
> After cloning, TCP sets the owner of the skb to the socket, so
> that should work fine.
>

OK, so maybe we don't need a per-skb field after all.

Paul
