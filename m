Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbZAOXtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbZAOXtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935275AbZAOXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:47:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935203AbZAOXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:47:55 -0500
Date: Thu, 15 Jan 2009 15:47:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson <arhuaco@freaks-unidos.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       andy@openmoko.com
Subject: Re: [PATCH 3/5] Add median filter
Message-Id: <20090115154724.fe722ce3.akpm@linux-foundation.org>
In-Reply-To: <20090113233955.26361.77565.stgit@fugue.noexisteestedominiotanlargo.biz>
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
	<20090113233955.26361.77565.stgit@fugue.noexisteestedominiotanlargo.biz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 18:39:55 -0500
Nelson <arhuaco@freaks-unidos.net> wrote:

> +static void ts_filter_median_del(int *p, int value, int count)
> +{
> +	int index;
> +
> +	for (index = 0; index < count; index++)
> +		if (p[index] == value) {
> +			for (; index < count; index++)
> +				p[index] = p[index + 1];
> +			return;
> +		}
> +}
> +
> +
> +static void ts_filter_median_clear_internal(struct ts_filter *tsf)
> +{
> +	struct ts_filter_median *tsfm = (struct ts_filter_median *)tsf;
> +
> +	tsfm->pos = 0;
> +	tsfm->valid = 0;
> +
> +}
> +static void ts_filter_median_clear(struct ts_filter *tsf)
> +{
> +	ts_filter_median_clear_internal(tsf);
> +
> +	if (tsf->next) /* chain */
> +		(tsf->next->api->clear)(tsf->next);
> +}

Again, the code seems to do an awful lot of browsing over
exernally-visible data structures while holding no locks.

