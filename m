Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYAWWGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYAWWGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYAWWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:06:13 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:65493 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbYAWWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:06:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJ9Il0dMQWYq/2dsb2JhbACBV6xf
Date: Wed, 23 Jan 2008 17:06:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: mbligh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace tracing memory mappings
Message-ID: <20080123220608.GD2282@Krystal>
References: <20080123160454.GA15405@Krystal> <1201117112.8329.9.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1201117112.8329.9.camel@nimitz.home.sr71.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:55:45 up 81 days,  3:01,  5 users,  load average: 0.99, 0.38,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> On Wed, 2008-01-23 at 11:04 -0500, Mathieu Desnoyers wrote:
> > Since memory management is not my speciality, I would like to know if
> > there are some implementation details I should be aware of for my
> > LTTng userspace tracing buffers. Here is what I want to do :
> 
> Can you start with a little background by telling us what a userspace
> tracing buffer _is_?  Maybe a few requirements about what you need it to
> do and why, as well?
> 
> -- Dave
> 

Sure,

Userspace tracing is :

- A userspace process wants to record information to a circular ring
  buffer. This information has a timestamp. It should disrupt the
  timings minimally. The timestamps must be synchronized with the
  timestamps given to the kernel trace events so we can analyze all the
  information together.

- When one subbuffer of the ring buffer is filled, the information is
  ready to be read by a "trace dumping" process and sent to disk or to
  the network. At this point, the traced process raises a flag that will
  be checked periodically by the OS to wake up the disk/network dumper
  daemon. (for future reference, I use the term "buffer writer" when I
  talk about the traced process and the term "buffer reader" when
  talking about the disk/network dumper daemon).

There is more information in the email I sent to Frank Eigler. Please
feel free to ask for more if I am not clear about specific points.

A lot of the background information is already explained in the kernel
tracing paper I presented at OLS2006, it might be a good start :

http://ltt.polymtl.ca/papers/desnoyers-ols2006.pdf

Another requirement I am trying to meet is protection of tracing buffers
against corruption coming from other userspace process. K42 implemented
their tracing buffers shared system-wide : with the OS too. The
processes have full access to the kernel buffers and can therefore
corrupt the whole system's trace. This is something I would like not to
allow.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
