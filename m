Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYAaBz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYAaBz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYAaBzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:55:49 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2419 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYAaBzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:55:48 -0500
Date: Thu, 31 Jan 2008 02:55:35 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1201659263.6766.40.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801310251090.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home> <1201659263.6766.40.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 29 Jan 2008, john stultz wrote:

> +/* Because using NSEC_PER_SEC would be too easy */
> +#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)

Why are you using USER_HZ? Did you test this with HZ!=100?
Anyway, please don't make more complicated than it already is.
What I said previously about the update interval is still valid, so the 
correct solution is to use the simpler NTP_INTERVAL_LENGTH calculation 
from my last mail and to omit the correction for NO_HZ.

bye, Roman
