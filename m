Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYB1KF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYB1KF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYB1KFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:05:52 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYB1KFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:05:52 -0500
Date: Thu, 28 Feb 2008 02:04:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sourceware.org,
       prasadav@us.ibm.com, hch@infradead.org
Subject: Re: [patch 2/3]  Trace code and documentation
Message-Id: <20080228020441.a08e4772.akpm@linux-foundation.org>
In-Reply-To: <1204065528.26964.17.camel@lc4eb748232119.ibm.com>
References: <1204065528.26964.17.camel@lc4eb748232119.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 14:38:48 -0800 "David J. Wilder" <dwilder@us.ibm.com> wrote:

> +	if (strncmp(buf, "start", strlen("start")) == 0) {
> +		ret = trace_start(trace);
> +		if (ret)
> +			return ret;
> +	} else if (strncmp(buf, "stop", strlen("stop")) == 0)
> +		trace_stop(trace);

Does gcc manage to avoid the pointless strlen() calls here?

It's a bit untidy that you can write "startfoo" in there and the kernel
will happily accept it.
