Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456Ab0AQTQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0AQTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389Ab0AQTQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:16:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:53513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0AQTQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:16:28 -0500
Date: Sun, 17 Jan 2010 11:16:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
 patching without stop_machine
Message-ID: <20100117111608.35a98ee2@infradead.org>
In-Reply-To: <20100117185539.GF9008@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com>
	<a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
	<1263483139.28171.3857.camel@gandalf.stny.rr.com>
	<4B4F3A1A.2030906@zytor.com>
	<20100117185539.GF9008@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 13:55:39 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * H. Peter Anvin (hpa@zytor.com) wrote:
> > On 01/14/2010 07:32 AM, Steven Rostedt wrote:
> > >> +
> > >> +	/* Replacing 1 byte can be done atomically. */
> > >> +	if (unlikely(len <= 1))
> > >> +		return text_poke(addr, opcode, len);
> > > 
> > > This part bothers me. The text_poke just writes over the text
> > > directly (using a separate mapping). But if that memory is in the
> > > pipeline of another CPU, I think this could cause a GPF.
> > > 
> > 
> > Could you clarify why you think that?
> 
> Basically, what Steven and I were concerned about in this particular
> patch version is the fact that this code took a "shortcut" for
> single-byte text modification, thus bypassing the int3-bypass scheme
> altogether.

single byte instruction updates are likely 100x safer than any scheme
of multi-byte instruction scheme that I have seen, other than a full
stop_machine().

That does not mean it is safe, it just means it's an order of
complexity less to analyze ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
