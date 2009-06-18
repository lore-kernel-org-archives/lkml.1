Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZFRGLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZFRGLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZFRGKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:10:53 -0400
Received: from mail-yx0-f180.google.com ([209.85.210.180]:56816 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZFRGKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pxZkfqcymK0U67H+nfFj4pXlcrc3lDID7yvJXf7c/rZ5A2RBb+spbTDT9x4xEm7zuv
         xJ2cK/wcRuwAlWSp6SGWSbl4G9Yx9Qexcx2whRzkDnS//O0JLcsAg/FAwxrYpUPN1idt
         rEBM0fb9FnLC2lJTv0OmwdWA1kCSeoCghHvJs=
Subject: Re: [PATCH 2/2] tracing/filters: remove error messages
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A39958C.4010801@cn.fujitsu.com>
References: <4A38AD7F.2070408@cn.fujitsu.com>
	 <4A38AD93.4070300@cn.fujitsu.com> <20090617120216.GB6064@nowhere>
	 <4A39958C.4010801@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 01:10:52 -0500
Message-Id: <1245305452.6207.91.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 09:17 +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Wed, Jun 17, 2009 at 04:47:15PM +0800, Li Zefan wrote:
> >> Now we restore original filter is the new one can't be applied,
> >> and no long show error messages, so we can remove them totally.
> > 
> > Why?
> > These messages are very powerful to point a user to its mistakes
> > in filters syntaxes or semantics.
> > 
> > I really think we are removing a very useful feature in this patch.
> > 
> 
> I think it's better done by providing a user-space program/script.
> 
> So what's the criterion to decide what should be in kernel and
> what should be in user-space?
> 

I thought there wasn't supposed to be any userspace for non-binary
tracing.  If there is, then yeah, you can get rid of the error messages
in the kernel because your userspace program can arrange to never submit
an erroneous filter.

> btw, this feature is not full-fledged, that it can't point to the
> exact position where error occured, and the implementation will add
> complexity and I'm sure it's worthy or not.
> 

It could, it just doesn't yet.  But even without exact position
information, the messages should still be useful in most cases.

Tom

> > May be we can keep the previous filter in case of new filter string
> > inserting failure, though if the user wanted to insert a new one, there
> > are few chances that the previous one is still relevant for him.
> > I don't know.
> > 
> >> Another reason is, I don't think it's good to show error messages
> >> when reading a control file.
> > 
> > So, why not create a filter_error file in this case? One for each
> > event and subsys that would print the last error?
> > 
> 
> Yeah, if we do want to keep this feature in the kernel.

