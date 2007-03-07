Return-Path: <linux-kernel-owner+w=401wt.eu-S1161169AbXCGCCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169AbXCGCCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXCGCCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:02:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbXCGCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:02:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hFoZzw0ZaC213wqpImPCqTokdajTdgl4ROWidZj0/ar/xuh1ViNB1CQAAJkRhys3/
	Y5ANJd8LArDuw27bsYi2g==
Message-ID: <6599ad830703061802g37629faayf7cb2a94bd74ce25@mail.gmail.com>
Date: Tue, 6 Mar 2007 18:02:32 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [RFC][PATCH 0/7] Resource controllers based on process containers
Cc: "Andrew Morton" <akpm@osdl.org>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>, devel@openvz.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, "Kirill Korotaev" <dev@sw.ru>
In-Reply-To: <45ED7DEC.7010403@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Pavel Emelianov <xemul@sw.ru> wrote:
> 2. Extended containers may register themselves too late.
>    Kernel threads/helpers start forking, opening files
>    and touching pages much earlier. This patchset
>    workarounds this in not-so-cute manner and I'm waiting
>    for Paul's comments on this issue.
>

Can we not make sure that each subsystem registers itself before any
of its resources become usable? So the file counting subsystem should
register at some point before filp_open() becomes usable, and the
process counting subsystem should register before it's possible to
fork, etc.

Paul
