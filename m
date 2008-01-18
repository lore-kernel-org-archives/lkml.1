Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYARIU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYARIU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYARIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:20:15 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:59218 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYARIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:20:13 -0500
Message-ID: <47906133.6010301@cateee.net>
Date: Fri, 18 Jan 2008 09:20:03 +0100
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org> <47905A95.4030500@cateee.net>
In-Reply-To: <47905A95.4030500@cateee.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And to demostrate that Linus is not the only person
with this view, I copy some paragraphs from C99 rationale
(you can find standard, rationale and other documents
in http://clc-wiki.net/wiki/C_standardisation:ISO )

Page 75 of C99 rationale:

Type qualifiers were introduced in part to provide greater control over optimization. Several
important optimization techniques are based on the principle of "cacheing": under certain
circumstances the compiler can remember the last value accessed (read or written) from a
location, and use this retained value the next time that location is read. (The memory, or
"cache", is typically a hardware register.) If this memory is a machine register, for instance, the
code can be smaller and faster using the register rather than accessing external memory.
The basic qualifiers can be characterized by the restrictions they impose on access and
cacheing:

const          No writes through this lvalue. In the absence of this qualifier, writes may occur
               through this lvalue.

volatile       No cacheing through this lvalue: each operation in the abstract semantics must
               be performed (that is, no cacheing assumptions may be made, since the location
               is not guaranteed to contain any previous value). In the absence of this qualifier,
               the contents of the designated location may be assumed to be unchanged except
               for possible aliasing.

restrict       Objects referenced through a restrict-qualified pointer have a special
               association with that pointer. All references to that object must directly or
               indirectly use the value of this pointer. In the absence of this qualifier, other
               pointers can alias this object. Cacheing the value in an object designated through
               a restrict-qualified pointer is safe at the beginning of the block in which the
               pointer is declared, because no pre-existing aliases may also be used to reference
               that object. The cached value must be restored to the object by the end of the
               block, where pre-existing aliases again become available. New aliases may be
               formed within the block, but these must all depend on the value of the
               restrict-qualified pointer, so that they can be identified and adjusted to refer
               to the cached value. For a restrict-qualified pointer at file scope, the block
               is the body of main.

ciao
	cate
