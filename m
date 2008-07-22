Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYGVMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYGVMOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYGVMOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:14:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYGVMOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:14:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Hx37Fk5QdPlLDTmVGnmCAwep2TVQnFoRXb+03jc5H/pTrJQiC4GHcCyXUzvygJ5sc
	eDXru4TMooUL+u7wKa4Xw==
Message-ID: <6599ad830807220514m5afea0fcsb99bf2e95f401c36@mail.gmail.com>
Date: Tue, 22 Jul 2008 08:14:16 -0400
From: "Paul Menage" <menage@google.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH] Traffic control cgroups subsystem
Cc: "Ranjit Manomohan" <ranjitm@google.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, lizf@cn.fujitsu.com
In-Reply-To: <4885B7DD.7070507@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807212100580.1760@ranjit.corp.google.com>
	 <4885B7DD.7070507@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 6:35 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> Does this really have to be a new skb member? You could
> simply use skb->sk->sk_cgroup_classid directly, or if
> that doesn't work, maybe skb->priority.
>

We were actually using skb->priority in our internal version of this
patch. I suggested that the separate cgroup_classid field be added
since it might be considered an abuse of skb->priority and would
interfere with existing users of that. If that's not an issue then
reusing skb->priority is certainly possible.

Regarding skb->sk->sk_cgroup_classid, is it always the case that the
original sk is still available when we're making traffic control
decisions? I'd thought that there were cases (e.g. cloning skbs in the
TCP retransmit path) where the pointer to the original sk is lost.

Paul
