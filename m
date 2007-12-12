Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbXLLLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbXLLLTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbXLLLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:19:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbXLLLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:19:08 -0500
Date: Wed, 12 Dec 2007 03:19:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/47] New version of CRISv32 I2C driver.
Message-Id: <20071212031905.5e4f5428.akpm@linux-foundation.org>
In-Reply-To: <1756cef44b33372567336fe3f7ec3f7896e67644.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<1756cef44b33372567336fe3f7ec3f7896e67644.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 15:54:01 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> +int
> +i2c_write(unsigned char theSlave, void *data, size_t nbytes)
> +{
> +	int error, cntr = 3;
> +	unsigned char bytes_wrote = 0;
> +	unsigned char value;
> +	unsigned long flags;
> +
> +	spin_lock(&i2c_lock);
> +
> +	do {
> +		error = 0;
> +		/*
> +		 * we don't like to be interrupted
> +		 */
> +		local_irq_save(flags);
> +
> +		i2c_start();
> +		/*

Well if you _are_ interrupted prior to the local_irq_save() you'll deadlock
on i2c_lock?

