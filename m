Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXLYXeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXLYXeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXLYXeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:34:13 -0500
Received: from ozlabs.org ([203.10.76.45]:51037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXLYXeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:34:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 01/16] introduce vcpu struct
Date: Wed, 26 Dec 2007 10:34:05 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576442148-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261034.06419.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:41 Glauber de Oliveira Costa wrote:
> this patch introduces a vcpu struct for lguest. In upcoming patches,
> more and more fields will be moved from the lguest struct to the vcpu

Hi Glommer,

> +static inline struct lguest *lg_of_vcpu(struct lguest_vcpu *vcpu)
> +{
> +	return container_of((vcpu - vcpu->vcpu_id), struct lguest, vcpus[0]);
> +}

I think this function is a bad idea: it contains implicit UP assumptions which 
aren't obvious to the caller.  vcpu->lg should do the same thing, no?

Rusty,
