Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYF1NOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYF1NOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYF1NOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:14:32 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29094 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbYF1NOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:14:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] fix extern inline errors with gcc 4.3.0
Date: Sat, 28 Jun 2008 09:10:19 -0400
Message-ID: <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fix extern inline errors with gcc 4.3.0
Thread-Index: AcjYePNRgv+ZTcVxTRmKp1thFyLFWQAp12CC
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <20080627162645.GC8381@c2.user-mode-linux.org>
From: "Halevy, Benny" <bhalevy@panasas.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: <user-mode-linux-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-27 19:26, Jeff Dike <jdike@addtoit.com> wrote:
> On Thu, Jun 26, 2008 at 04:50:51PM +0300, Benny Halevy wrote:
> > -KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
> > +# Disable unit-at-a-time mode on pre-gcc-4.3 compilers, it makes gcc use
> > +# a lot more stack due to the lack of sharing of stacklots:
> > +# gcc 4.3.0 needs -funit-at-a-time for extern inline functions
> > +KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0403 ] ; then \
> > +			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
> 
> How do we know that this patch won't cause the same crash reported in
> http://marc.info/?l=linux-kernel&m=121011722806093&w=2?

I don't know what was the root cause for the crash you mentioned.
FWIW, with these options UML/x86_64 builds on Fedora 9, w/ gcc 4.3.0
and runs well for me.

Benny

> 
> 				Jeff
> 
> -- 
> Work email - jdike at linux dot intel dot com
> 
