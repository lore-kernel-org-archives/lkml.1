Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYLAUvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYLAUvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYLAUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:51:27 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37346 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYLAUv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:51:26 -0500
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <493447DD.7010102@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
	 <20081128101919.GO28946@ZenIV.linux.org.uk>
	 <1228153645.2971.36.camel@nimitz>  <493447DD.7010102@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 12:51:19 -0800
Message-Id: <1228164679.2971.91.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 15:23 -0500, Oren Laadan wrote:
> Verifying that the size doesn't change does not ensure that the table's
> contents remained the same, so we can still end up with obsolete data.

With the realloc() scheme, we have virtually no guarantees about how the
fdtable that we read relates to the source.  All that we know is that
the n'th fd was at this value at *some* time.

Using the scheme that I just suggested (and you evidently originally
used) at least guarantees that we have an atomic copy of the fdtable.

Why is this done in two steps?  It first grabs a list of fd numbers
which needs to be validated, then goes back and turns those into 'struct
file's which it saves off.  Is there a problem with doing that
fd->'struct file' conversion under the files->file_lock?

-- Dave

