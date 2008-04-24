Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYDXWCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYDXWCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYDXWCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:02:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40897 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYDXWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:02:37 -0400
Date: Thu, 24 Apr 2008 23:01:57 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080424220157.GA26179@flint.arm.linux.org.uk>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	npiggin@suse.de, torvalds@linux-foundation.org,
	peterz@infradead.org, sam@ravnborg.org
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:50:17PM +0200, Jens Axboe wrote:
> +		data->csd.func(data->csd.info);
> +
> +		spin_lock(&data->lock);
> +		cpu_clear(cpu, data->cpumask);
> +		WARN_ON(data->refs == 0);
> +		data->refs--;
> +		refs = data->refs;

Probably a silly question, but what does data->refs do that
cpus_empty(data->cpumask) wouldn't do?  (as indeed ARM presently does.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
