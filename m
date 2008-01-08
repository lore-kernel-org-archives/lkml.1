Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYAHLDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYAHLDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYAHLCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:02:49 -0500
Received: from ozlabs.org ([203.10.76.45]:34493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbYAHLCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:02:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 04/16] per-cpu run guest
Date: Tue, 8 Jan 2008 22:02:27 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <1199711137195-git-send-email-gcosta@redhat.com> <11997111523234-git-send-email-gcosta@redhat.com> <1199711157132-git-send-email-gcosta@redhat.com>
In-Reply-To: <1199711157132-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082202.28263.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 00:05:25 Glauber de Oliveira Costa wrote:
> +	/* Watch out for arbitrary vcpu indexes! */
> +	if (vcpu_id > lg->nr_vcpus)
> +		return -EINVAL;
> +
> +	vcpu = &lg->vcpus[vcpu_id];
> +

Out-by-one error here... Fixed it for you, plus a couple of others.

I've applied the patches, but made one minor-but-invasive change: I didn't 
want to ask you to spin the patches again!

I changed "vcpu" to "cpu" everywhere (the v is pretty redundant in this 
context), which cut about a dozen lines of code out (things now fitted 
again!).

I also changed "vcpu_id" to simply "id" and made it unsigned.  Do you plan for 
this to always be equal to the index in the vcpu array BTW?  If so, we can 
neaten vcpu_start (now lg_cpu_start)...

You can grab the latest now...

Thanks!
Rusty.
