Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXHVRvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXHVRvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764871AbXHVRut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:50:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38100 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764148AbXHVRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:50:48 -0400
Date: Wed, 22 Aug 2007 10:50:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: bug in migrate page
In-Reply-To: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0708221049230.13436@schroedinger.engr.sgi.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Shaohua Li wrote:

> commit dc386d4d1e98bb39fb967ee156cd456c802fc692 adds rcu_read_lock, but
> some routines in the lock range might sleep (like lock_buffer,
> aops->writepage), I saw a 'sleep in atomic' warning. It appears the
> patch has several versions before. Doing rcu_read_lock in PageAnon
> sounds break the case of PageAnon(page) && PageSwapCache(page),
> as .writepage might be called. The dummy anon patch maybe is ok.

Ok so we agree that .writepage is not used. Anonymous pages also do not
not have buffers. Only taking the rcu lock on page_anon() would suffice 
to fix this right?

