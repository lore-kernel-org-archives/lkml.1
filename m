Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXDAGaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXDAGaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbXDAGaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:30:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXDAGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:30:07 -0400
Date: Sat, 31 Mar 2007 23:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-Id: <20070331232957.e1c93f19.akpm@linux-foundation.org>
In-Reply-To: <m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<20070331071220.GA26910@aitel.hist.no>
	<20070331005303.354411f0.akpm@linux-foundation.org>
	<20070401052932.GA9894@amd64.of.nowhere>
	<m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2007 00:15:51 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Does anyone know how to express the constraint of a 2M aligned number in Kconfig?

Nope, but we could make CONFIG_PHYSICAL_START be in units of 2MB, which
would be a bit hard to use.

Adding a BUILD_BUG_ON which checks this constraint might help.  Plus a
useful comment right at the BUILD_BUG_ON site explaining what to do about
it.

