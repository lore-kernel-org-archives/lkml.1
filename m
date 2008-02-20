Return-Path: <linux-kernel-owner+w=401wt.eu-S934689AbYBTXLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689AbYBTXLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932832AbYBTXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:11:19 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:60068 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S932311AbYBTXLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:11:18 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 21 Feb 2008 10:10:44 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: serge@hallyn.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 2.6.25-rc2 3/9] config: Improve init/Kconfig help	descriptions - namespaces
Message-ID: <20080220231044.GG2169@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org> <20080219151028.GA28294@tull.net> <47BAF2E5.8050001@openvz.org> <20080219084420.f3104e3f.randy.dunlap@oracle.com> <20080220121915.GA2169@tull.net> <20080220165034.GA14550@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220165034.GA14550@vino.hallyn.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:50:34AM -0600, serge@hallyn.com wrote:
> thanks for all this work.
> 
> Perhaps it would be better to have a Documentation/Namespaces/PID file
> describing these semantics, and have the description read something
> briefer like
> 
> 	  Pid namespaces provide filtered views of processes and their
> 	  process ids.  This features is used to implement containers.
> 	  Please see Documentation/Namespaces/PID for details.
> 
> But in any case with Pavel's comments this looks very good.

I'm sure you're right, but my goal is to improve all the Kconfig help
messages (clarity, accuracy, consistency) and so at this time I want
to limit myself to changes to the help descriptions.

If somebody will add documentation for this or any other subsystem
I will gladly refer to it but in the meantime I'm sure we can come up
with a wording which everybody can agree with.

The point of view I'm coming from is that of a non-kernel-developer
who has to make a choice about some feature of the kernel which they
don't understand. When I'm configuring a kernel I appreciate a bit more
detail in the help text.  I want to provide enough information to help
the user make a rational choice, or give them some idea about what they
are agreeing to put into their kernel. If they still don't understand,
there will be a suggested safe answer.

I'll see if I can make it briefer, if there's any fat which can be
trimmed away.

Current wording:

@@ -446,12 +486,20 @@ config PID_NS
        default n
        depends on NAMESPACES && EXPERIMENTAL
        help
-         Suport process id namespaces.  This allows having multiple
-         process with the same pid as long as they are in different
-         pid namespaces.  This is a building block of containers.
+         Enable experimental support for hierarchical process id namespaces.

-         Unless you want to work with an experimental feature
-         say N here.
+         Process IDs will be unique only within each PID namespace.
+         This allows multiple processes to have the same PID
+         so long as they are in different PID namespaces. Furthermore,
+         each process will have a distinct PID in each namespace
+         the process is in.
+
+         This is used by container systems (i.e. vservers).
+         Tasks in the container are placed in the PID namespace
+         corresponding to the container, and cannot see or
+         affect processes in any parent PID namespaces.
+
+         If unsure, say N.

 config BLK_DEV_INITRD
        bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"


Nick.
