Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881AbXCYTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbXCYTX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCYTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:23:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50796 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXCYTX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:23:28 -0400
Date: Sun, 25 Mar 2007 12:23:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documention for trace records (trec).
Message-Id: <20070325122351.6ce69dfd.randy.dunlap@oracle.com>
In-Reply-To: <11747802992043-git-send-email-wink@saville.com>
References: <11747802992043-git-send-email-wink@saville.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 16:51:37 -0700 Wink Saville wrote:

> Trec is a light weight tracing mechanism that places
> trace information into a buffer. The contents of the
> buffer is dumped when errors occurs or when enabled
> via SYSRQ commands.
> 
> Signed-off-by: Wink Saville <wink@saville.com>
> ---
>  Documentation/trec.txt |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/trec.txt
> 
> diff --git a/Documentation/trec.txt b/Documentation/trec.txt
> new file mode 100644
> index 0000000..2275edd
> --- /dev/null
> +++ b/Documentation/trec.txt
> @@ -0,0 +1,87 @@
> +Title	: Trace Records
> +Authors	: Wink Saville <wink@saville.com>
> +
> +CONTENTS
> +
> +1. Concepts
> +2. Architectures Supported
> +3. Configuring
> +4. API Reference
> +5. Overhead
> +6. TODO
> +
> +
> +1. Concepts
> +
> +Trace records are a light weight tracing technique that time stamps

                       lightweight                 ...     timestamps

> +small amounts of information and stores them in a buffer. TREC's are
> +light enough that they may be sprinkled most anywhere in the kernel
> +and have very little performance impact.
> +
> +For instance they can be placed in the scheduler and ISR's to watch
> +the interaction between ISR's and the scheduler. They can be placed
> +in memory handling routines to determine how and when memory is
> +allocated and freed.
> +
> +In the current default configuration the trec's are dumped by calling
> +trec_print_snapshot when die() or panic() are called as well as when

                                             is

> +the kernel itself page faults in do_page_fault.
> +
> +If CONFIG_MAGIC_SYSRQ is the 'y' command will execute trec_snapshot
                           ^
                           enabled,

> +and the 'z' command will print the current snapshot.
> +
> +A general macro TREC allows trec_write to be invoked as a macro and
> +TRECC allows it to be invoked conditionally. See include/linux/trec.h
> +for the current set of macros.
> +
> +2. Architectures Supported
> +
> +Should support all architectures has been tested only on:
                                   ^
                                   ;
> +
> +- X86_64
> +
> +
> +3. Configuring
> +
> +Since trec's are implemented as a device driver they are configured
> +by enabling support in the "Device Drivers" section of as they could
                                                         ^
                                                         ??

> +be used early being a module is not supported.
> +
> +
> +4. API Reference
> +
> +Trec supports the following API:
> +
> +void trec_init(void):
> +
> +  Initialize the module, this may be called before the driver is loaded
                          ^
                          ; (or maybe :)

> +  if it is desired to use trec's early.
> +
> +void trec_write(unsigned long pc, int pid, unsigned long v1, unsigned long v2);
> +
> +  This is the routine used to write into the buffer. pc is the program counter

end above line with ,

> +  pid is the process id and v1 and v2 are two parameters.
> +
> +void trec_snapshot(void);
> +
> +  Calling this function takes a snapshot of the current trec buffer so that it
> +  will not be modified. This is called prior to printing the snapshot via
> +  trec_print_snapshot.
> +
> +void trec_print_snapshot(void);
> +
> +  Print the snapshot.
> +
> +5. Overhead
> +
> +Measured on a 2.4GHZ Core 2 Duo the readings between two TREC's is
> +270 tics of the rdtsc or about 0.1us. No attempt has been made to
> +optimize and less information can be collected if the overhead
> +is still to high.

            too

> +
> +
> +6. TODO
> +
> +a. Add code to dump trec to user space
> +b. Enhance to allow runtime registration and runtime enable disable.
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
