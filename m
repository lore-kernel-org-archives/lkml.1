Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXKBVkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXKBVkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXKBVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:40:36 -0400
Received: from thunk.org ([69.25.196.29]:33832 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbXKBVkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:40:35 -0400
Date: Fri, 2 Nov 2007 17:39:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071102213920.GB18029@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Emelyanov <xemul@openvz.org>,
	Ulrich Drepper <drepper@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Sukadev Bhattiprolu <sukadev@us.ibm.com>,
	Serge Hallyn <serue@us.ibm.com>
References: <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org> <472B4378.80809@redhat.com> <472B4937.1050106@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472B4937.1050106@openvz.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 06:58:47PM +0300, Pavel Emelyanov wrote:
> Having access to the same IPCs in different pid namespaces won't work.
> Having access to the same filesystem in different IPC namespaces won't work.
> Having access to the same UID namespace in different VFS namespaces won't work.
> Having access to the same <any> namespace in different <many others> namespace
>  wont' work.
> 
> That's the idea OpenVZ tried to promote when the story with "containers"
> started, but most of the other participants decided that we can create
> individual namespaces and step-by-step try to make them work in all the
> possible combinations.

Heh.  Well, this won't be the first time that we go around the design
circle wiht people objecting with the idea eventually figuring out
that the original idea really was the only sane way to do things.  :-)

Maybe it would be instructive to create a matrix which lists areas
where processes that share namespace FOO but not namespace BAR would
result in breakage, with an explanation of what breaks in a particular
instance?  Assuming we continue to go down the path of orthogonal
namespace, having a file in Documentation/ which lists places where
there different namepsaces have dependencies on each other for correct
system call operation would be a Good Thing.

       	           	    	      	       	      - Ted
