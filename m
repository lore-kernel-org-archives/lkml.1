Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0BXAqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:46:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0BXAqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:46:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Xypmq/MdFWL4avFi95q49GbQRhIjcQeGU+mozjDiyGypeyDuBJrOxM+O7yDxZRXKL
	vfnyliKvkAmpYlaJKoNXw==
MIME-Version: 1.0
In-Reply-To: <1266838378.3962.10.camel@centos51>
References: <1266838378.3962.10.camel@centos51>
Date: Tue, 23 Feb 2010 16:45:59 -0800
Message-ID: <6599ad831002231645g7a53f7bbkda4c7d3cfad2d71@mail.gmail.com>
Subject: Re: [PATCH] cpuset: Update the cpuset flag file from old name from 
	new name correctly.
From: Paul Menage <menage@google.com>
To: leemgs1@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 3:32 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
>
> Dear Jiri Kosina,
>
> This is a trivial patch for cpuset feature.
> Current document file for cpuset is still not updated.
> So, I made this patch that updated cpusets.txt based on linux-2.6.33-rc8.
>
> Regards,
> Geunsik Lim.
>
>
> >From 1fedbe5698e4bc892e795d68da826320f9e1fa1b Mon Sep 17 00:00:00 2001
> From: GeunSik,Lim <leemgs1@gmail.com>
> Date: Mon, 22 Feb 2010 20:05:03 +0900
> Subject: [PATCH] cpuset: Update the cpuset flag file from old name from new name.
>
> This patch is for modifying with correct cuset flag file.
> We need to update current manual for cpuset.
> For example,
> before) cpus, cpu_exclusive, mems
> after ) cpuset.cpus, cpuset.cpu_exclusive, cpuset.mems
>
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>

Looks reasonable, thanks.

There are some bits in the docs where the "cpuset." prefix isn't
really needed, but I guess it's better to be consistent.

Acked-by: Paul Menage <menage@google.com>

> ---
>  Documentation/cgroups/cpusets.txt |  127 +++++++++++++++++++------------------
>  1 files changed, 65 insertions(+), 62 deletions(-)
>
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 1d7e978..4160df8 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -168,20 +168,20 @@ Each cpuset is represented by a directory in the cgroup file system
>  containing (on top of the standard cgroup files) the following
>  files describing that cpuset:
>
> - - cpus: list of CPUs in that cpuset
> - - mems: list of Memory Nodes in that cpuset
> - - memory_migrate flag: if set, move pages to cpusets nodes
> - - cpu_exclusive flag: is cpu placement exclusive?
> - - mem_exclusive flag: is memory placement exclusive?
> - - mem_hardwall flag:  is memory allocation hardwalled
> - - memory_pressure: measure of how much paging pressure in cpuset
> - - memory_spread_page flag: if set, spread page cache evenly on allowed nodes
> - - memory_spread_slab flag: if set, spread slab cache evenly on allowed nodes
> - - sched_load_balance flag: if set, load balance within CPUs on that cpuset
> - - sched_relax_domain_level: the searching range when migrating tasks
> + - cpuset.cpus: list of CPUs in that cpuset
> + - cpuset.mems: list of Memory Nodes in that cpuset
> + - cpuset.memory_migrate flag: if set, move pages to cpusets nodes
> + - cpuset.cpu_exclusive flag: is cpu placement exclusive?
> + - cpuset.mem_exclusive flag: is memory placement exclusive?
> + - cpuset.mem_hardwall flag:  is memory allocation hardwalled
> + - cpuset.memory_pressure: measure of how much paging pressure in cpuset
> + - cpuset.memory_spread_page flag: if set, spread page cache evenly on allowed nodes
> + - cpuset.memory_spread_slab flag: if set, spread slab cache evenly on allowed nodes
> + - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
> + - cpuset.sched_relax_domain_level: the searching range when migrating tasks
>
>  In addition, the root cpuset only has the following file:
> - - memory_pressure_enabled flag: compute memory_pressure?
> + - cpuset.memory_pressure_enabled flag: compute memory_pressure?
>
>  New cpusets are created using the mkdir system call or shell
>  command.  The properties of a cpuset, such as its flags, allowed
> @@ -229,7 +229,7 @@ If a cpuset is cpu or mem exclusive, no other cpuset, other than
>  a direct ancestor or descendant, may share any of the same CPUs or
>  Memory Nodes.
>
> -A cpuset that is mem_exclusive *or* mem_hardwall is "hardwalled",
> +A cpuset that is cpuset.mem_exclusive *or* cpuset.mem_hardwall is "hardwalled",
>  i.e. it restricts kernel allocations for page, buffer and other data
>  commonly shared by the kernel across multiple users.  All cpusets,
>  whether hardwalled or not, restrict allocations of memory for user
> @@ -304,15 +304,15 @@ times 1000.
>  ---------------------------
>  There are two boolean flag files per cpuset that control where the
>  kernel allocates pages for the file system buffers and related in
> -kernel data structures.  They are called 'memory_spread_page' and
> -'memory_spread_slab'.
> +kernel data structures.  They are called 'cpuset.memory_spread_page' and
> +'cpuset.memory_spread_slab'.
>
> -If the per-cpuset boolean flag file 'memory_spread_page' is set, then
> +If the per-cpuset boolean flag file 'cpuset.memory_spread_page' is set, then
>  the kernel will spread the file system buffers (page cache) evenly
>  over all the nodes that the faulting task is allowed to use, instead
>  of preferring to put those pages on the node where the task is running.
>
> -If the per-cpuset boolean flag file 'memory_spread_slab' is set,
> +If the per-cpuset boolean flag file 'cpuset.memory_spread_slab' is set,
>  then the kernel will spread some file system related slab caches,
>  such as for inodes and dentries evenly over all the nodes that the
>  faulting task is allowed to use, instead of preferring to put those
> @@ -337,21 +337,21 @@ their containing tasks memory spread settings.  If memory spreading
>  is turned off, then the currently specified NUMA mempolicy once again
>  applies to memory page allocations.
>
> -Both 'memory_spread_page' and 'memory_spread_slab' are boolean flag
> +Both 'cpuset.memory_spread_page' and 'cpuset.memory_spread_slab' are boolean flag
>  files.  By default they contain "0", meaning that the feature is off
>  for that cpuset.  If a "1" is written to that file, then that turns
>  the named feature on.
>
>  The implementation is simple.
>
> -Setting the flag 'memory_spread_page' turns on a per-process flag
> +Setting the flag 'cpuset.memory_spread_page' turns on a per-process flag
>  PF_SPREAD_PAGE for each task that is in that cpuset or subsequently
>  joins that cpuset.  The page allocation calls for the page cache
>  is modified to perform an inline check for this PF_SPREAD_PAGE task
>  flag, and if set, a call to a new routine cpuset_mem_spread_node()
>  returns the node to prefer for the allocation.
>
> -Similarly, setting 'memory_spread_slab' turns on the flag
> +Similarly, setting 'cpuset.memory_spread_slab' turns on the flag
>  PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
>  pages from the node returned by cpuset_mem_spread_node().
>
> @@ -404,24 +404,24 @@ the following two situations:
>     system overhead on those CPUs, including avoiding task load
>     balancing if that is not needed.
>
> -When the per-cpuset flag "sched_load_balance" is enabled (the default
> -setting), it requests that all the CPUs in that cpusets allowed 'cpus'
> +When the per-cpuset flag "cpuset.sched_load_balance" is enabled (the default
> +setting), it requests that all the CPUs in that cpusets allowed 'cpuset.cpus'
>  be contained in a single sched domain, ensuring that load balancing
>  can move a task (not otherwised pinned, as by sched_setaffinity)
>  from any CPU in that cpuset to any other.
>
> -When the per-cpuset flag "sched_load_balance" is disabled, then the
> +When the per-cpuset flag "cpuset.sched_load_balance" is disabled, then the
>  scheduler will avoid load balancing across the CPUs in that cpuset,
>  --except-- in so far as is necessary because some overlapping cpuset
>  has "sched_load_balance" enabled.
>
> -So, for example, if the top cpuset has the flag "sched_load_balance"
> +So, for example, if the top cpuset has the flag "cpuset.sched_load_balance"
>  enabled, then the scheduler will have one sched domain covering all
> -CPUs, and the setting of the "sched_load_balance" flag in any other
> +CPUs, and the setting of the "cpuset.sched_load_balance" flag in any other
>  cpusets won't matter, as we're already fully load balancing.
>
>  Therefore in the above two situations, the top cpuset flag
> -"sched_load_balance" should be disabled, and only some of the smaller,
> +"cpuset.sched_load_balance" should be disabled, and only some of the smaller,
>  child cpusets have this flag enabled.
>
>  When doing this, you don't usually want to leave any unpinned tasks in
> @@ -433,7 +433,7 @@ scheduler might not consider the possibility of load balancing that
>  task to that underused CPU.
>
>  Of course, tasks pinned to a particular CPU can be left in a cpuset
> -that disables "sched_load_balance" as those tasks aren't going anywhere
> +that disables "cpuset.sched_load_balance" as those tasks aren't going anywhere
>  else anyway.
>
>  There is an impedance mismatch here, between cpusets and sched domains.
> @@ -443,19 +443,19 @@ overlap and each CPU is in at most one sched domain.
>  It is necessary for sched domains to be flat because load balancing
>  across partially overlapping sets of CPUs would risk unstable dynamics
>  that would be beyond our understanding.  So if each of two partially
> -overlapping cpusets enables the flag 'sched_load_balance', then we
> +overlapping cpusets enables the flag 'cpuset.sched_load_balance', then we
>  form a single sched domain that is a superset of both.  We won't move
>  a task to a CPU outside it cpuset, but the scheduler load balancing
>  code might waste some compute cycles considering that possibility.
>
>  This mismatch is why there is not a simple one-to-one relation
> -between which cpusets have the flag "sched_load_balance" enabled,
> +between which cpusets have the flag "cpuset.sched_load_balance" enabled,
>  and the sched domain configuration.  If a cpuset enables the flag, it
>  will get balancing across all its CPUs, but if it disables the flag,
>  it will only be assured of no load balancing if no other overlapping
>  cpuset enables the flag.
>
> -If two cpusets have partially overlapping 'cpus' allowed, and only
> +If two cpusets have partially overlapping 'cpuset.cpus' allowed, and only
>  one of them has this flag enabled, then the other may find its
>  tasks only partially load balanced, just on the overlapping CPUs.
>  This is just the general case of the top_cpuset example given a few
> @@ -468,23 +468,23 @@ load balancing to the other CPUs.
>  1.7.1 sched_load_balance implementation details.
>  ------------------------------------------------
>
> -The per-cpuset flag 'sched_load_balance' defaults to enabled (contrary
> +The per-cpuset flag 'cpuset.sched_load_balance' defaults to enabled (contrary
>  to most cpuset flags.)  When enabled for a cpuset, the kernel will
>  ensure that it can load balance across all the CPUs in that cpuset
>  (makes sure that all the CPUs in the cpus_allowed of that cpuset are
>  in the same sched domain.)
>
> -If two overlapping cpusets both have 'sched_load_balance' enabled,
> +If two overlapping cpusets both have 'cpuset.sched_load_balance' enabled,
>  then they will be (must be) both in the same sched domain.
>
> -If, as is the default, the top cpuset has 'sched_load_balance' enabled,
> +If, as is the default, the top cpuset has 'cpuset.sched_load_balance' enabled,
>  then by the above that means there is a single sched domain covering
>  the whole system, regardless of any other cpuset settings.
>
>  The kernel commits to user space that it will avoid load balancing
>  where it can.  It will pick as fine a granularity partition of sched
>  domains as it can while still providing load balancing for any set
> -of CPUs allowed to a cpuset having 'sched_load_balance' enabled.
> +of CPUs allowed to a cpuset having 'cpuset.sched_load_balance' enabled.
>
>  The internal kernel cpuset to scheduler interface passes from the
>  cpuset code to the scheduler code a partition of the load balanced
> @@ -495,9 +495,9 @@ all the CPUs that must be load balanced.
>  The cpuset code builds a new such partition and passes it to the
>  scheduler sched domain setup code, to have the sched domains rebuilt
>  as necessary, whenever:
> - - the 'sched_load_balance' flag of a cpuset with non-empty CPUs changes,
> + - the 'cpuset.sched_load_balance' flag of a cpuset with non-empty CPUs changes,
>  - or CPUs come or go from a cpuset with this flag enabled,
> - - or 'sched_relax_domain_level' value of a cpuset with non-empty CPUs
> + - or 'cpuset.sched_relax_domain_level' value of a cpuset with non-empty CPUs
>    and with this flag enabled changes,
>  - or a cpuset with non-empty CPUs and with this flag enabled is removed,
>  - or a cpu is offlined/onlined.
> @@ -542,7 +542,7 @@ As the result, task B on CPU X need to wait task A or wait load balance
>  on the next tick.  For some applications in special situation, waiting
>  1 tick may be too long.
>
> -The 'sched_relax_domain_level' file allows you to request changing
> +The 'cpuset.sched_relax_domain_level' file allows you to request changing
>  this searching range as you like.  This file takes int value which
>  indicates size of searching range in levels ideally as follows,
>  otherwise initial value -1 that indicates the cpuset has no request.
> @@ -559,8 +559,8 @@ The system default is architecture dependent.  The system default
>  can be changed using the relax_domain_level= boot parameter.
>
>  This file is per-cpuset and affect the sched domain where the cpuset
> -belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
> -is disabled, then 'sched_relax_domain_level' have no effect since
> +belongs to.  Therefore if the flag 'cpuset.sched_load_balance' of a cpuset
> +is disabled, then 'cpuset.sched_relax_domain_level' have no effect since
>  there is no sched domain belonging the cpuset.
>
>  If multiple cpusets are overlapping and hence they form a single sched
> @@ -607,9 +607,9 @@ from one cpuset to another, then the kernel will adjust the tasks
>  memory placement, as above, the next time that the kernel attempts
>  to allocate a page of memory for that task.
>
> -If a cpuset has its 'cpus' modified, then each task in that cpuset
> +If a cpuset has its 'cpuset.cpus' modified, then each task in that cpuset
>  will have its allowed CPU placement changed immediately.  Similarly,
> -if a tasks pid is written to another cpusets 'tasks' file, then its
> +if a tasks pid is written to another cpusets 'cpuset.tasks' file, then its
>  allowed CPU placement is changed immediately.  If such a task had been
>  bound to some subset of its cpuset using the sched_setaffinity() call,
>  the task will be allowed to run on any CPU allowed in its new cpuset,
> @@ -622,8 +622,8 @@ and the processor placement is updated immediately.
>  Normally, once a page is allocated (given a physical page
>  of main memory) then that page stays on whatever node it
>  was allocated, so long as it remains allocated, even if the
> -cpusets memory placement policy 'mems' subsequently changes.
> -If the cpuset flag file 'memory_migrate' is set true, then when
> +cpusets memory placement policy 'cpuset.mems' subsequently changes.
> +If the cpuset flag file 'cpuset.memory_migrate' is set true, then when
>  tasks are attached to that cpuset, any pages that task had
>  allocated to it on nodes in its previous cpuset are migrated
>  to the tasks new cpuset. The relative placement of the page within
> @@ -631,12 +631,12 @@ the cpuset is preserved during these migration operations if possible.
>  For example if the page was on the second valid node of the prior cpuset
>  then the page will be placed on the second valid node of the new cpuset.
>
> -Also if 'memory_migrate' is set true, then if that cpusets
> -'mems' file is modified, pages allocated to tasks in that
> -cpuset, that were on nodes in the previous setting of 'mems',
> +Also if 'cpuset.memory_migrate' is set true, then if that cpusets
> +'cpuset.mems' file is modified, pages allocated to tasks in that
> +cpuset, that were on nodes in the previous setting of 'cpuset.mems',
>  will be moved to nodes in the new setting of 'mems.'
>  Pages that were not in the tasks prior cpuset, or in the cpusets
> -prior 'mems' setting, will not be moved.
> +prior 'cpuset.mems' setting, will not be moved.
>
>  There is an exception to the above.  If hotplug functionality is used
>  to remove all the CPUs that are currently assigned to a cpuset,
> @@ -678,8 +678,8 @@ and then start a subshell 'sh' in that cpuset:
>   cd /dev/cpuset
>   mkdir Charlie
>   cd Charlie
> -  /bin/echo 2-3 > cpus
> -  /bin/echo 1 > mems
> +  /bin/echo 2-3 > cpuset.cpus
> +  /bin/echo 1 > cpuset.mems
>   /bin/echo $$ > tasks
>   sh
>   # The subshell 'sh' is now running in cpuset Charlie
> @@ -725,10 +725,13 @@ Now you want to do something with this cpuset.
>
>  In this directory you can find several files:
>  # ls
> -cpu_exclusive  memory_migrate      mems                      tasks
> -cpus           memory_pressure     notify_on_release
> -mem_exclusive  memory_spread_page  sched_load_balance
> -mem_hardwall   memory_spread_slab  sched_relax_domain_level
> +cpuset.cpu_exclusive       cpuset.memory_spread_slab
> +cpuset.cpus                cpuset.mems
> +cpuset.mem_exclusive       cpuset.sched_load_balance
> +cpuset.mem_hardwall        cpuset.sched_relax_domain_level
> +cpuset.memory_migrate      notify_on_release
> +cpuset.memory_pressure     tasks
> +cpuset.memory_spread_page
>
>  Reading them will give you information about the state of this cpuset:
>  the CPUs and Memory Nodes it can use, the processes that are using
> @@ -736,13 +739,13 @@ it, its properties.  By writing to these files you can manipulate
>  the cpuset.
>
>  Set some flags:
> -# /bin/echo 1 > cpu_exclusive
> +# /bin/echo 1 > cpuset.cpu_exclusive
>
>  Add some cpus:
> -# /bin/echo 0-7 > cpus
> +# /bin/echo 0-7 > cpuset.cpus
>
>  Add some mems:
> -# /bin/echo 0-7 > mems
> +# /bin/echo 0-7 > cpuset.mems
>
>  Now attach your shell to this cpuset:
>  # /bin/echo $$ > tasks
> @@ -774,28 +777,28 @@ echo "/sbin/cpuset_release_agent" > /dev/cpuset/release_agent
>  This is the syntax to use when writing in the cpus or mems files
>  in cpuset directories:
>
> -# /bin/echo 1-4 > cpus         -> set cpus list to cpus 1,2,3,4
> -# /bin/echo 1,2,3,4 > cpus     -> set cpus list to cpus 1,2,3,4
> +# /bin/echo 1-4 > cpuset.cpus          -> set cpus list to cpus 1,2,3,4
> +# /bin/echo 1,2,3,4 > cpuset.cpus      -> set cpus list to cpus 1,2,3,4
>
>  To add a CPU to a cpuset, write the new list of CPUs including the
>  CPU to be added. To add 6 to the above cpuset:
>
> -# /bin/echo 1-4,6 > cpus       -> set cpus list to cpus 1,2,3,4,6
> +# /bin/echo 1-4,6 > cpuset.cpus        -> set cpus list to cpus 1,2,3,4,6
>
>  Similarly to remove a CPU from a cpuset, write the new list of CPUs
>  without the CPU to be removed.
>
>  To remove all the CPUs:
>
> -# /bin/echo "" > cpus          -> clear cpus list
> +# /bin/echo "" > cpuset.cpus           -> clear cpus list
>
>  2.3 Setting flags
>  -----------------
>
>  The syntax is very simple:
>
> -# /bin/echo 1 > cpu_exclusive  -> set flag 'cpu_exclusive'
> -# /bin/echo 0 > cpu_exclusive  -> unset flag 'cpu_exclusive'
> +# /bin/echo 1 > cpuset.cpu_exclusive   -> set flag 'cpuset.cpu_exclusive'
> +# /bin/echo 0 > cpuset.cpu_exclusive   -> unset flag 'cpuset.cpu_exclusive'
>
>  2.4 Attaching processes
>  -----------------------
> --
> 1.7.0
>
>
>
> -----------------------------------------------
> To unsubscribe from this list: send the line "unsubscribe linux-***"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> GeunSik Lim ( Samsung Electronics )
> e-Mail  :1) geunsik.lim@samsung.com
>         2) leemgs@gmail.com , leemgs1@gmail.com
> HomePage: http://blog.naver.com/invain/
> -----------------------------------------------
>
>
