Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYK0BE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYK0BE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYK0BER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:04:17 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42087 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYK0BER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:04:17 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 20:04:16 EST
Date: Thu, 27 Nov 2008 02:07:53 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 4/5] Protect cinit from fatal signals
Message-ID: <20081127010753.GB13545@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034634.GD23238@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081126034634.GD23238@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 07:46:34PM -0800, Sukadev Bhattiprolu wrote:
> To protect container-init from fatal signals, set SIGNAL_UNKILLABLE but
> clear it if it receives SIGKILL from parent namespace - so it is still
> killable from ancestor namespace.

This sounds like a workaround.

> Note that container-init is still somewhat special compared to 'normal
> processes' - unhandled fatal signals like SIGUSR1 to a container-init
> are dropped even if they are from ancestor namespace. SIGKILL from an
> ancestor namespace is the only reliable way to kill a container-init.

It sounds not right to make this special case for a "normal" process.

However, no idea how to do this better.

Bastian

-- 
The heart is not a logical organ.
		-- Dr. Janet Wallace, "The Deadly Years", stardate 3479.4
