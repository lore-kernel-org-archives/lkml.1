Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYDWROE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYDWROE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYDWRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:13:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYDWRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:13:52 -0400
Date: Wed, 23 Apr 2008 10:13:11 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Message-Id: <20080423101311.d7420a13.zaitcev@redhat.com>
In-Reply-To: <84144f020804230034y3d31fb02n597b69d7ed866260@mail.gmail.com>
References: <200804212310.41729.elendil@planet.nl>
	<20080422134034.GF7311@elte.hu>
	<20080422235148.c49dc6b7.zaitcev@redhat.com>
	<84144f020804230031w612176c1k8ec5a6fb27ca3315@mail.gmail.com>
	<84144f020804230034y3d31fb02n597b69d7ed866260@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 10:34:57 +0300, "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> On Wed, Apr 23, 2008 at 10:31 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >  On Wed, Apr 23, 2008 at 9:51 AM, Pete Zaitcev <zaitcev@redhat.com> wrote:

> >  >  I looked at this whole day today, but found nothing.
> >  >
> >  >  The code analysis for usbmon shows nothing. Anyone wants to have
> >  >  a look?
> 
> >  I didn't look too closely but mon_text_fetch() does list_del() but no
> >  kmem_cache_free() which looks fishy.
> 
> Yup, looks like a leak in the error path. So it's mon_text_read_t() ->
> mon_text_read_wait() -> mon_text_fetch() that removes it from the list
> but we can fail before we reach the kmem_cache_free() in
> mon_text_read_t() and thus lose track of the object.

This is false, we cannot fail. There's only one "return" for non-NULL
case and the kmem_cache_free is right in front of it. See my reply
to the patch.

-- Pete
