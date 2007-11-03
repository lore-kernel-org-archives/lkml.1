Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXKCX4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXKCX4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbXKCXzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:55:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54439 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbXKCXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:55:54 -0400
Date: Sat, 3 Nov 2007 16:55:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071103165525.2dcd55c7@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
References: <20071101144307.GA29566@elte.hu>
	<4729E7E4.8070208@openvz.org>
	<4729E936.4040400@redhat.com>
	<4729EB3C.9050102@openvz.org>
	<472A6D91.1020300@redhat.com>
	<472AD7D6.80900@openvz.org>
	<20071102010419.23f3db5c.akpm@linux-foundation.org>
	<1194024622.6271.108.camel@localhost>
	<alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
	<20071103201251.GB26366@elte.hu>
	<alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007 15:40:48 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I don't understand how you can call this a "PID namespace design
> bug", when it clearly has nothing what-so-ever to do with pid
> namespaces, and everything to do with the *futexes* that blithely
> assume that pid's are unique and that made it part of the
> user-visible interface.
> 
> OF COURSE any pid namespace design will always break such
> assumptions, but that's not because of any PID namespace bugs. It's
> what the whole *point* of PID namespaces are. If you use pid's
> (instead of some opaque cookies), you will not be able to use such
> things across pid-separation.

well... kind of.
THere are 2 things around pid namespaces: which pids you can see/touch
(in proc or signals or otherwise), and the non-uniqueness.

For containers you clearly want the first part... but... is there a
strong reason to not just *not* create duplicate pids even across
namespaces? there's no rule in posix or anything similar to fd's afaik
concerning which pids we can hand out... so we could just make then
unique globally but just with limited visibility....
