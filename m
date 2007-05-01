Return-Path: <linux-kernel-owner+w=401wt.eu-S1946065AbXEAXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946065AbXEAXjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946070AbXEAXjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:39:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33570 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946065AbXEAXja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:39:30 -0400
Date: Tue, 1 May 2007 16:42:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, hjk@linutronix.de
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-Id: <20070501164239.00d209c8.randy.dunlap@oracle.com>
In-Reply-To: <11777142633770-git-send-email-gregkh@suse.de>
References: <20070427224957.GA17967@kroah.com>
	<11777142582534-git-send-email-gregkh@suse.de>
	<11777142633770-git-send-email-gregkh@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 15:50:57 -0700 Greg Kroah-Hartman wrote:

> From: Hans J. Koch <hjk@linutronix.de>
> 
> Documentation for the UIO interface
> 
> From: Hans J. Koch <hjk@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  Documentation/DocBook/kernel-api.tmpl |    4 +
>  Documentation/DocBook/uio-howto.tmpl  |  498 +++++++++++++++++++++++++++++++++
>  2 files changed, 502 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/uio-howto.tmpl

> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> new file mode 100644
> index 0000000..bd2209f
> --- /dev/null
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -0,0 +1,498 @@
> +<?xml version="1.0" encoding="UTF-8"?>
> +<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
> +"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">
> +
> +<article id="index">
> +<articleinfo>
> +<title>The Userspace I/O HOWTO</title>

Most of this reads well.  Thanks.
A few typo corrections are below...


But it doesn't build for me with 'make htmldocs'.
Did you test it?

Warning(/tester/linsrc/linux-2.6.21-rc7-mm2//drivers/uio/uio.c:240): No description found for parameter 'info'
Warning(/tester/linsrc/linux-2.6.21-rc7-mm2//drivers/uio/uio.c:594): No description found for parameter 'owner'
Warning(/tester/linsrc/linux-2.6.21-rc7-mm2//drivers/uio/uio.c:594): No description found for parameter 'info'
Warning(/tester/linsrc/linux-2.6.21-rc7-mm2//drivers/uio/uio.c:667): No description found for parameter 'info'
Error(/tester/linsrc/linux-2.6.21-rc7-mm2//include/linux/uio_driver.h:29): cannot understand prototype: 'struct uio_mem '
Error(/tester/linsrc/linux-2.6.21-rc7-mm2//include/linux/uio_driver.h:55): cannot understand prototype: 'struct uio_info '
Warning(/tester/linsrc/linux-2.6.21-rc7-mm2//include/linux/uio_driver.h): no structured comments found

Patch below for all of is these (including typos).

However, it still fails 'make htmldocs' for me.
What am I missing?  How did it work for you?
My DTD doesn't like to see <varname> inside a <listitem>:


linux-2.6.21-rc7-mm2/Documentation/DocBook/uio-howto.xml:333: element listitem: validity error : Element listitem content does not follow the DTD, expecting (calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | caution | important | note | tip | warning | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable | equation | example | figure | table | msgset | procedure | sidebar | qandaset | anchor | bridgehead | remark | highlights | abstract | authorblurb | epigraph | indexterm | beginpage)+, got (varname CDATA)


so I removed most of the <varname>s and still had errors.
Any suggestions?


...

> +	<para>
> +	Each driver provides attributes that are used to read or write
> +	variables. These attributes are accessible through sysfs
> +	files.  A custom kernel driver module can add its own
> +	attributes to the device owned by the uio driver, but not added
> +	to the UIO device itself at this time.  This might change in the
> +	future if it would be found to be useful

Period at end of sentence.

> +	</para>
> +
> +	<para>
> +	The following standard attributes are provided by the UIO
> +	framework:
> +	</para>

> <listitem>
> +<varname>void *internal_addr</varname>: If you have to access this memory
> +region from within your kernel module, you will want to map it internally by
> +using something like <function>ioremap_nocache()</function>. Addresses
> +returned by this function can not be mapped to user space, so you must not

                             cannot

> +store it in <varname>addr</varname>. Use <varname>internal_addr</varname>
> +instead to remember such an address.
> +</listitem>
> +</itemizedlist>

> +<sect2 id="adding_irq_handler">
> +<title>Adding an interrupt handler</title>
> +	<para>
> +	What you need to do in your interrupt handler depends on your
> +	hardware and on how you want to	handle it. You should try to
> +	keep the amount of code in your kernel interrupt handler low.
> +	If your hardware requires no action that you
> +	<emphasis>have</emphasis> to perform after each interrupt,
> +	then your handler can be empty.</para> <para>If, on the other
> +	hand, your hardware <emphasis>needs</emphasis> some action to
> +	be performed after each interrupt, then you
> +	<emphasis>must</emphasis> do it in your kernel module. Note
> +	that you cannot rely on the userspace part of your driver.Your

                                                                 . Your

> +	userspace program can terminate at any time, possibly leaving
> +	your hardware in a state where proper interrupt handling is
> +	still required.
> +	</para>



Some fixes:

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix UIO kernel-doc typos and warnings.
Include uio-howto in list of docbook files.
Change DOCTYPE version to same as all other docbook files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile       |    2 +-
 Documentation/DocBook/uio-howto.tmpl |   10 +++++-----
 drivers/uio/uio.c                    |   10 +++++-----
 include/linux/uio_driver.h           |    8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)

--- linux-2.6.21-rc7-mm2.orig/include/linux/uio_driver.h
+++ linux-2.6.21-rc7-mm2/include/linux/uio_driver.h
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 
 /**
- * uio_mem - description of a UIO memory region
+ * struct uio_mem - description of a UIO memory region
  * @kobj:		kobject for this mapping
  * @addr:		address of the device's memory
  * @size:		size of IO
@@ -39,13 +39,13 @@ struct uio_mem {
 struct uio_device;
 
 /**
- * uio_info - UIO device capabilities
+ * struct uio_info - UIO device capabilities
  * @uio_dev:		the UIO device this info belongs to
  * @name:		device name
  * @version:		device driver version
  * @mem:		list of mappable memory regions, size==0 for end of list
  * @irq:		interrupt number or UIO_IRQ_CUSTOM
- * @irq_flags		flags for request_irq()
+ * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
  * @mmap:		mmap operation for this uio device
@@ -56,7 +56,7 @@ struct uio_info {
 	struct uio_device	*uio_dev;
 	char			*name;
 	char			*version;
-	struct uio_mem		mem[ MAX_UIO_MAPS ];
+	struct uio_mem		mem[MAX_UIO_MAPS];
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
--- linux-2.6.21-rc7-mm2.orig/drivers/uio/uio.c
+++ linux-2.6.21-rc7-mm2/drivers/uio/uio.c
@@ -234,7 +234,7 @@ static void uio_free_minor(struct uio_de
 
 /**
  * uio_event_notify - trigger an interrupt event
- * @idev: UIO device where the event occured
+ * @info: UIO device capabilities
  */
 void uio_event_notify(struct uio_info *info)
 {
@@ -582,9 +582,9 @@ static void uio_class_destroy(void)
 
 /**
  * uio_register_device - register a new userspace IO device
- *
+ * @owner:	module pointer
  * @parent:	parent device
- * @idev:	device capabilities
+ * @info:	device capabilities
  *
  * returns zero on success or a negative error code.
  */
@@ -658,8 +658,8 @@ err_kzalloc:
 EXPORT_SYMBOL_GPL(__uio_register_device);
 
 /**
- * uio_unregister_device - unregister a industrial IO device
- * @uiodev:	UIO device driver identifier
+ * uio_unregister_device - unregister an industrial IO device
+ * @info:	UIO device driver capabilities
  *
  * returns 0 on success
  */
--- linux-2.6.21-rc7-mm2.orig/Documentation/DocBook/uio-howto.tmpl
+++ linux-2.6.21-rc7-mm2/Documentation/DocBook/uio-howto.tmpl
@@ -1,6 +1,6 @@
 <?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
-"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">
+<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd">
 
 <article id="index">
 <articleinfo>
@@ -182,7 +182,7 @@ interested in translating it, please ema
 	files.  A custom kernel driver module can add its own
 	attributes to the device owned by the uio driver, but not added
 	to the UIO device itself at this time.  This might change in the
-	future if it would be found to be useful
+	future if it would be found to be useful.
 	</para>
 
 	<para>
@@ -422,7 +422,7 @@ all unused mappings.
 <varname>void *internal_addr</varname>: If you have to access this memory
 region from within your kernel module, you will want to map it internally by
 using something like <function>ioremap_nocache()</function>. Addresses
-returned by this function can not be mapped to user space, so you must not
+returned by this function cannot be mapped to user space, so you must not
 store it in <varname>addr</varname>. Use <varname>internal_addr</varname>
 instead to remember such an address.
 </listitem>
@@ -447,7 +447,7 @@ to set up sysfs files for this mapping. 
 	hand, your hardware <emphasis>needs</emphasis> some action to
 	be performed after each interrupt, then you
 	<emphasis>must</emphasis> do it in your kernel module. Note
-	that you cannot rely on the userspace part of your driver.Your
+	that you cannot rely on the userspace part of your driver. Your
 	userspace program can terminate at any time, possibly leaving
 	your hardware in a state where proper interrupt handling is
 	still required.
--- linux-2.6.21-rc7-mm2.orig/Documentation/DocBook/Makefile
+++ linux-2.6.21-rc7-mm2/Documentation/DocBook/Makefile
@@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml
+	    genericirq.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
