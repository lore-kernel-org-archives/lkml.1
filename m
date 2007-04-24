Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXDXKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXDXKc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXDXKcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:32:55 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10221 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbXDXKcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:32:55 -0400
Date: Tue, 24 Apr 2007 14:40:48 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: roland@redhat.com, akpm@osdl.org
Cc: magnus_vesterlund@hotmail.com, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [Devel] [PATCH -mm] utrace: fix double free re __rcu_process_callbacks()
Message-ID: <20070424104048.GB10539@localhost.sw.ru>
References: <20070424091023.GA10539@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070424091023.GA10539@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 01:10:23PM +0400, Alexey Dobriyan wrote:
> ¹ But I see whole can of other bugs! I think they were already lurking
>   but weren't easily reproducable without hitting double-free first.
>   FWIW, it's
>   	BUG_ON(!list_empty(&tsk->ptracees));

mmm, pretty easily reproduced with:

	while true; do
		killall -9 expl_ptratt 2>/dev/null;
		killall -9 exe 2>/dev/null;
		sleep 2;
	done
vs
	while true; do ./expl_ptratt; done

