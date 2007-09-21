Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbXIUBEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbXIUBEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXIUBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:04:18 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:44336 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXIUBER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:04:17 -0400
Date: Thu, 20 Sep 2007 21:03:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 4/4] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070921010338.GB4951@goodmis.org>
References: <20070918211324.161373216@polymtl.ca> <20070918211500.117442517@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918211500.117442517@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:13:28PM -0400, Mathieu Desnoyers wrote:
> +void blk_probe_disarm(void)
> +{
> +	int i, err;
> +
> +	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
> +		err = marker_disarm(probe_array[i].name);
> +		BUG_ON(err);
> +		err = IS_ERR(marker_probe_unregister(probe_array[i].name));
> +		BUG_ON(err);
> +	}
> +}

As well as changing these to WARN_ON.

-- Steve

