Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbYBTVcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbYBTVcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYBTVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:32:24 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:49352 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752185AbYBTVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:32:23 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 21 Feb 2008 08:31:50 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: serge@hallyn.com
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-ID: <20080220213150.GD2169@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net> <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com> <20080220025431.GA10766@tull.net> <20080220165507.GB14550@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220165507.GB14550@vino.hallyn.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:55:07AM -0600, serge@hallyn.com wrote:
> Quoting Nick Andrew (nick@nick-andrew.net):
> > On Tue, Feb 19, 2008 at 06:04:57PM -0800, Paul Menage wrote:
> 
> Maybe 
> 	  Control Groups enable processes to be grouped into "cgroups"
> 	  to facilitate tracking and resource management.  For example
> 	  a cgroup can tie a set of processes to a set of cpus using
> 	  "cpusets".

That is much nicer, thanks.

> > 	  When enabled, a new filesystem type "cgroup" is available
> > 	  and can be mounted to control cpusets and other
> > 	  resource/behaviour controllers.

I thought of something better to say than this.  Enabling a new
pseudo filesystem is interesting, but it's not the main point.

Now:


 config CGROUPS
        bool "Control Group support"
        help
-         This option will let you use process cgroup subsystems
-         such as Cpusets
+         Control Groups enable processes to be grouped into "cgroups"
+         to facilitate tracking and resource management. For example
+         a cgroup can tie a set of processes to a set of CPUs using
+         "cpusets".

-         Say N if unsure.
+         See <file:Documentation/cgroups.txt> for more information.
+
+         If you say Y here, you probably want to enable one or
+         more of the cgroup subsystem options below.
+
+         If unsure, say N.


Regarding GROUP_SCHED and CGROUP_SCHED I am confused, what is the
difference between these two options?

config GROUP_SCHED
        bool "Group CPU scheduler"
        default y
        help
          This feature enables the CPU scheduler to recognize task groups
          and control CPU bandwidth allocation to such task groups.

          See <file:Documentation/sched-design-CFS.txt> for more information.


[...]

config CGROUP_SCHED
        bool "Control groups"
        depends on CGROUPS
        help
          This option allows you to create arbitrary task groups
          using the "cgroup" pseudo filesystem and control
          the CPU bandwidth allocated to each such task group.

          See <file:Documentation/cgroups.txt> for more information
          on the "cgroup" pseudo filesystem.

Also with the titles, IMHO "Control Group support" is semantically
equivalent to "Control groups" so I am doubly confused.

Nick.
