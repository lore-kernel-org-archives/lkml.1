Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXFNKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXFNKK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXFNKKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:10:19 -0400
Received: from main.gmane.org ([80.91.229.2]:56785 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXFNKKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:10:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH RFC] struct list_node
Date: Thu, 14 Jun 2007 10:03:51 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f4r3q7$fin$1@sea.gmane.org>
References: <1181452290.16428.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 15:11:30 +1000, Rusty Russell wrote:

>  
> +/* A list node is the same as the head of the list, but it's useful to
> + * think of them as a separate type. */
> +struct list_node {
> +	struct list_head h;
> +};
> +
> +/* This allows us to support old style list_head as well as list_node. */
> +union list_head_or_node {
> +	struct list_head *_h;
> +	struct list_node *_n;
> +};
> +union list_head_or_node_const {
> +	struct list_head *_h;
> +	struct list_node *_n;
> +	const struct list_head *_ch;
> +	const struct list_node *_cn;
> +};
> +#define __lh(n) (((union list_head_or_node)(n))._h)
> +#define __clh(n) (((union list_head_or_node_const)(n))._h)
> +

Any reason why you don't use __attribute__ ((transparent_union)) ? I guess
this is exactly the case for which it was invented.

Cheers,
Jan

