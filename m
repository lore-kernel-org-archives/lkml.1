Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJ3Iof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJ3Iof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYJ3Io1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:44:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYJ3Io0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:44:26 -0400
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 09:44:45 +0100
Message-Id: <1225356285.7803.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:

> +/*
> + * Determine the dirty ratios for the currently active cpuset
> + */
> +void cpuset_get_current_dirty_ratios(int *background, int *throttle)
> +{
> +	mutex_lock(&callback_mutex);
> +	task_lock(current);
> +	*background = task_cs(current)->dirty_background_ratio;
> +	*throttle = task_cs(current)->cpuset_dirty_ratio;
> +	task_unlock(current);
> +	mutex_unlock(&callback_mutex);
> +
> +	if (*background == -1)
> +		*background = dirty_background_ratio;
> +	if (*throttle == -1)
> +		*throttle = vm_dirty_ratio;
> +}

That's rather an awful lot of locking to read just two integers.


