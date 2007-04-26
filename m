Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXDZBoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXDZBoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423030AbXDZBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:44:00 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2589 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbXDZBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:43:58 -0400
Date: Thu, 26 Apr 2007 05:39:16 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, maxextreme@gmail.com, gregkh@suse.de,
       jschopp@austin.ibm.com
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-ID: <20070426013916.GA8219@zarina>
Reply-To: cbou@mail.ru
References: <20070423141123.GA21174@skybase> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <200704260232.06909.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704260232.06909.arnd@arndb.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:32:06AM +0200, Arnd Bergmann wrote:
> On Thursday 26 April 2007, Andrew Morton wrote:
> > It would be neat if someone could create and maintain a new
> > scripts/spot-common-mistakes. šFeed it a unified diff and it would complain
> > about newly-added code (and only newly-added code) which has busted
> > whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.
> 
> http://patchstylecheck.googlecode.com/svn/trunk/patchstylecheckemail.pl
> Might serve as a starting point for this. It doesn't have any semantic
> checks right now, but I guess they can be added.

Had run this utility against my battery patches, and caught
bunch of false positives (I believe).


+#define BATTERY_PROP(bat, prop) ({                                 \
+	void *value = bat->get_property(bat, BATTERY_PROP_##prop); \
+	value ? *(int*)value : 0;                                  \
+})

Got: "Macros with multiple statements should be enclosed in a do - while
loop"

I believed ({}) is equivalent for "do - while", it's widely used in
kernel.


+	switch (bp) {
+	default: break;
+	};

Got "Gotos should not be indented", at "default: break;"


+static int bind_pst_to_psy(struct power_supplicant *pst,
+                           struct power_supply *psy)
+{

Got "use tabs not spaces". Here spaces intentionally used for
formatting purpose, not for the indenting.
