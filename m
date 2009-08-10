Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZHJJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZHJJu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZHJJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:50:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:58510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHJJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:50:26 -0400
Subject: Re: perf: store and retrieve trace event names in the perf.data
 file
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A7F4463.3050508@linux.intel.com>
References: <4A7F4463.3050508@linux.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 11:50:05 +0200
Message-Id: <1249897805.17467.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the CC :-)

On Sun, 2009-08-09 at 14:49 -0700, Arjan van de Ven wrote:
> +static void store_event_type(const char *orgname)
> +{
> +       char filename[PATH_MAX], *c;
> +       FILE *file;
> +       int id;
> +
> +       sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);

That should be using debugfs_path, as it stands this thing won't work on
any of my machines.

> +       c = strchr(filename, ':');
> +       if (c) *c = '/';
> +
> +       file = fopen(filename, "r");
> +       if (!file)
> +               return;
> +       fscanf(file, "%i", &id);
> +       fclose(file);
> +       perf_header__push_event(id, orgname);
> +}
