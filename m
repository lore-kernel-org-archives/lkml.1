Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXECGjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXECGjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030938AbXECGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:39:45 -0400
Received: from www.osadl.org ([213.239.205.134]:50159 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030776AbXECGjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:39:43 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 3 May 2007 08:39:13 +0200
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <20070502163734.070d5047.randy.dunlap@oracle.com> <20070503053731.GA17864@kroah.com>
In-Reply-To: <20070503053731.GA17864@kroah.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ROYOGBJ7SMXhVKb"
Message-Id: <200705030839.13675.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Donnerstag 03 Mai 2007 07:37 schrieb Greg KH:
> On Wed, May 02, 2007 at 04:37:34PM -0700, Randy Dunlap wrote:
> > On Thu, 3 May 2007 00:00:28 +0200 Hans-J?rgen Koch wrote:
> > 
> > > Am Mittwoch 02 Mai 2007 schrieb Randy Dunlap:
> > > > On Wed, 2 May 2007 10:41:35 +0200 Hans-J?rgen Koch wrote:
> > > > > Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:
> > > > > > > +<title>The Userspace I/O HOWTO</title>
> > > > > >
> > > > > > Most of this reads well.  Thanks.
> > > > > > A few typo corrections are below...
> > > > >
> > > > > Thank you for your work. I generated a new patch that includes all your
> > > > > suggestions and also fixes the build problems.
> > 
> > OK, your fixes all look good, but still needs one minor fix (below).
> > 
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Hm, I have about 3 different patches here now, all dependant on each
> other, yet I can't tell which goes first :(
> 
> Can someone just send me 1, or 3 with the correct order in which to
> apply them?
> 
> thanks,
> 
> greg k-h
>

Hi Greg,
I attached all the UIO patches I collected so far. This is my series file:

uio.patch
fix-early-irq-problem-in-uio.patch
uio-documentation.patch
fix-uio_read-type-problem.patch
uio-dummy.patch
uio-hilscher-cif-card-driver.patch
ioremap-in-uio-hilscher-cif.patch
add-userspace-howto-to-uio-doc.patch
fix-uio-doc-build-problems.patch

It should also work without uio-dummy.patch.
I added Randy's last one-line patch to fix-uio-doc-build-problems.patch.

All patches are
Signed-off-by: Hans J. Koch <hjk@linutronix.de>

fix-uio-doc-build-problems.patch is also
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks,
Hans







--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-uio-doc-build-problems.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-uio-doc-build-problems.patch"

Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-05-02 08:32:19.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-05-03 08:21:39.000000000 +0200
@@ -234,7 +234,7 @@
 
 /**
  * uio_event_notify - trigger an interrupt event
- * @idev: UIO device where the event occured
+ * @info: UIO device capabilities
  */
 void uio_event_notify(struct uio_info *info)
 {
@@ -582,9 +582,9 @@
 
 /**
  * uio_register_device - register a new userspace IO device
- *
+ * @owner:	module that creates the new device
  * @parent:	parent device
- * @idev:	device capabilities
+ * @info:	UIO device capabilities
  *
  * returns zero on success or a negative error code.
  */
@@ -660,9 +660,8 @@
 
 /**
  * uio_unregister_device - unregister a industrial IO device
- * @uiodev:	UIO device driver identifier
+ * @info:	UIO device capabilities
  *
- * returns 0 on success
  */
 void uio_unregister_device(struct uio_info *info)
 {
Index: linux-2.6.22-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.22-rc.orig/include/linux/uio_driver.h	2007-05-02 08:24:38.000000000 +0200
+++ linux-2.6.22-rc/include/linux/uio_driver.h	2007-05-02 08:42:42.000000000 +0200
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 
 /**
- * uio_mem - description of a UIO memory region
+ * struct uio_mem - description of a UIO memory region
  * @kobj:		kobject for this mapping
  * @addr:		address of the device's memory
  * @size:		size of IO
@@ -39,13 +39,13 @@
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
@@ -56,7 +56,7 @@
 	struct uio_device	*uio_dev;
 	char			*name;
 	char			*version;
-	struct uio_mem		mem[ MAX_UIO_MAPS ];
+	struct uio_mem		mem[MAX_UIO_MAPS];
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
Index: linux-2.6.22-rc/Documentation/DocBook/Makefile
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/Makefile	2007-05-02 09:00:32.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/Makefile	2007-05-02 09:43:06.000000000 +0200
@@ -11,7 +11,7 @@
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml
+	    genericirq.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
Index: linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/uio-howto.tmpl	2007-05-02 08:54:24.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl	2007-05-02 10:24:18.000000000 +0200
@@ -1,9 +1,9 @@
 <?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
-"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
+"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" []>
 
-<article id="index">
-<articleinfo>
+<book id="index">
+<bookinfo>
 <title>The Userspace I/O HOWTO</title>
 
 <author>
@@ -48,13 +48,13 @@
 	<revremark>First draft.</revremark>
 	</revision>
 </revhistory>
-</articleinfo>
+</bookinfo>
 
-<sect1 id="aboutthisdoc">
+<chapter id="aboutthisdoc">
 <?dbhtml filename="about.html"?>
 <title>About this document</title>
 
-<sect2 id="copyright">
+<sect1 id="copyright">
 <?dbhtml filename="copyright.html"?>
 <title>Copyright and License</title>
 <para>
@@ -63,9 +63,9 @@
 This documentation is Free Software licensed under the terms of the
 GPL version 2.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="translations">
+<sect1 id="translations">
 <?dbhtml filename="translations.html"?>
 <title>Translations</title>
 
@@ -73,9 +73,9 @@
 interested in translating it, please email me
 <email>hjk@linutronix.de</email>.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="preface">
+<sect1 id="preface">
 <title>Preface</title>
 	<para>
 	For many types of devices, creating a Linux kernel driver is
@@ -94,25 +94,25 @@
 	user space. This simplifies development and reduces the risk of
 	serious bugs within a kernel module.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="thanks">
+<sect1 id="thanks">
 <title>Acknowledgments</title>
 	<para>I'd like to thank Thomas Gleixner and Benedikt Spranger of
 	Linutronix, who have not only written most of the UIO code, but also
 	helped greatly writing this HOWTO by giving me all kinds of background
 	information.</para>
-</sect2>
+</sect1>
 
-<sect2 id="feedback">
+<sect1 id="feedback">
 <title>Feedback</title>
 	<para>Find something wrong with this document? (Or perhaps something
 	right?) I would love to hear from you. Please email me at
 	<email>hjk@linutronix.de</email>.</para>
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="about">
+<chapter id="about">
 <?dbhtml filename="about.html"?>
 <title>About UIO</title>
 
@@ -139,7 +139,7 @@
 </listitem>
 </itemizedlist>
 
-<sect2 id="how_uio_works">
+<sect1 id="how_uio_works">
 <title>How UIO works</title>
 	<para>
 	Each UIO device is accessed through a device file and several
@@ -188,7 +188,7 @@
 	files.  A custom kernel driver module can add its own
 	attributes to the device owned by the uio driver, but not added
 	to the UIO device itself at this time.  This might change in the
-	future if it would be found to be useful
+	future if it would be found to be useful.
 	</para>
 
 	<para>
@@ -264,10 +264,10 @@
 offset = N * getpagesize();
 </programlisting>
 
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="using-uio_dummy" xreflabel="Using uio_dummy">
+<chapter id="using-uio_dummy" xreflabel="Using uio_dummy">
 <?dbhtml filename="using-uio_dummy.html"?>
 <title>Using uio_dummy</title>
 	<para>
@@ -277,7 +277,7 @@
 	kernel module that you will have to write yourself.
 	</para>
 
-<sect2 id="what_uio_dummy_does">
+<sect1 id="what_uio_dummy_does">
 <title>What uio_dummy does</title>
 	<para>
 	The kernel module <filename>uio_dummy.ko</filename> creates a
@@ -316,10 +316,10 @@
 	Use <function>cat count</function> to see how the interrupt
 	frequency changes.
 	</para>
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="custom_kernel_module" xreflabel="Writing your own kernel module">
+<chapter id="custom_kernel_module" xreflabel="Writing your own kernel module">
 <?dbhtml filename="custom_kernel_module.html"?>
 <title>Writing your own kernel module</title>
 	<para>
@@ -328,7 +328,7 @@
 	sections of this file.
 	</para>
 
-<sect2 id="uio_info">
+<sect1 id="uio_info">
 <title>struct uio_info</title>
 	<para>
 	This structure tells the framework the details of your driver,
@@ -336,24 +336,24 @@
 	</para>
 
 <itemizedlist>
-<listitem>
+<listitem><para>
 <varname>char *name</varname>: Required. The name of your driver as
 it will appear in sysfs. I recommend using the name of your module for this.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>char *version</varname>: Required. This string appears in
 <filename>/sys/class/uio/uioX/version</filename>.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>struct uio_mem mem[ MAX_UIO_MAPS ]</varname>: Required if you
 have memory that can be mapped with <function>mmap()</function>. For each
 mapping you need to fill one of the <varname>uio_mem</varname> structures.
 See the description below for details.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>long irq</varname>: Required. If your hardware generates an
 interrupt, it's your modules task to determine the irq number during
 initialization. If you don't have a hardware generated interrupt but
@@ -363,35 +363,35 @@
 routine. If you had no interrupt at all, you could set
 <varname>irq</varname> to <varname>UIO_IRQ_NONE</varname>, though this
 rarely makes sense.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long irq_flags</varname>: Required if you've set
 <varname>irq</varname> to a hardware interrupt number. The flags given
 here will be used in the call to <function>request_irq()</function>.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*mmap)(struct uio_info *info, struct vm_area_struct
 *vma)</varname>: Optional. If you need a special
 <function>mmap()</function> function, you can set it here. If this
 pointer is not NULL, your <function>mmap()</function> will be called
 instead of the built-in one.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*open)(struct uio_info *info, struct inode *inode)
 </varname>: Optional. You might want to have your own
 <function>open()</function>, e.g. to enable interrupts only when your
 device is actually used.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*release)(struct uio_info *info, struct inode *inode)
 </varname>: Optional. If you define your own
 <function>open()</function>, you will probably also want a custom
 <function>release()</function> function.
-</listitem>
+</para></listitem>
 </itemizedlist>
 
 <para>
@@ -402,36 +402,36 @@
 </para>
 
 <itemizedlist>
-<listitem>
+<listitem><para>
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
 <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
 memory (e.g. allocated with <function>kmalloc()</function>). There's also
 <varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long addr</varname>: Required if the mapping is used.
 Fill in the address of your memory block. This address is the one that
 appears in sysfs.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long size</varname>: Fill in the size of the
 memory block that <varname>addr</varname> points to. If <varname>size</varname>
 is zero, the mapping is considered unused. Note that you
 <emphasis>must</emphasis> initialize <varname>size</varname> with zero for
 all unused mappings.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>void *internal_addr</varname>: If you have to access this memory
 region from within your kernel module, you will want to map it internally by
-using something like <function>ioremap_nocache()</function>. Addresses
-returned by this function can not be mapped to user space, so you must not
+using something like <function>ioremap()</function>. Addresses
+returned by this function cannot be mapped to user space, so you must not
 store it in <varname>addr</varname>. Use <varname>internal_addr</varname>
 instead to remember such an address.
-</listitem>
+</para></listitem>
 </itemizedlist>
 
 <para>
@@ -439,9 +439,9 @@
 <varname>struct uio_mem</varname>! It is used by the UIO framework
 to set up sysfs files for this mapping. Simply leave it alone.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="adding_irq_handler">
+<sect1 id="adding_irq_handler">
 <title>Adding an interrupt handler</title>
 	<para>
 	What you need to do in your interrupt handler depends on your
@@ -453,7 +453,7 @@
 	hand, your hardware <emphasis>needs</emphasis> some action to
 	be performed after each interrupt, then you
 	<emphasis>must</emphasis> do it in your kernel module. Note
-	that you cannot rely on the userspace part of your driver.Your
+	that you cannot rely on the userspace part of your driver. Your
 	userspace program can terminate at any time, possibly leaving
 	your hardware in a state where proper interrupt handling is
 	still required.
@@ -486,11 +486,11 @@
 	frequently happens on the PC platform, you can save yourself a
 	lot of trouble by supporting interrupt sharing.
 	</para>
-</sect2>
-
 </sect1>
 
-<sect1 id="userspace_driver" xreflabel="Writing a driver in user space">
+</chapter>
+
+<chapter id="userspace_driver" xreflabel="Writing a driver in user space">
 <?dbhtml filename="userspace_driver.html"?>
 <title>Writing a driver in userspace</title>
 	<para>
@@ -502,7 +502,7 @@
 	userspace application.
 	</para>
 
-<sect2 id="getting_uio_information">
+<sect1 id="getting_uio_information">
 <title>Getting information about your UIO device</title>
 	<para>
 	Information about all UIO devices is available in sysfs. The
@@ -534,9 +534,9 @@
 	The file <filename>uio_helper.c</filename> contains a lot of
 	functions you could use in your userspace driver code.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="mmap_device_memory">
+<sect1 id="mmap_device_memory">
 <title>mmap() device memory</title>
 	<para>
 	After you made sure you've got the right device with the
@@ -561,9 +561,9 @@
 	A drawback of this technique is that memory is always
 	mapped beginning with its start address.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="wait_for_interrupts">
+<sect1 id="wait_for_interrupts">
 <title>Waiting for interrupts</title>
 	<para>
 	After you successfully mapped your devices memory, you
@@ -590,10 +590,10 @@
 	You can also use <function>select()</function> on
 	<filename>/dev/uioX</filename>.
 	</para>
-</sect2>
-
 </sect1>
 
+</chapter>
+
 <appendix id="app1">
 <title>Further information</title>
 <itemizedlist>
@@ -608,4 +608,4 @@
 </itemizedlist>
 </appendix>
 
-</article>
+</book>

--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-early-irq-problem-in-uio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-early-irq-problem-in-uio.patch"

Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-04-28 20:01:02.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-04-28 20:15:00.000000000 +0200
@@ -633,6 +633,8 @@
 	if (ret)
 		goto err_uio_dev_add_attributes;
 
+	info->uio_dev = idev;
+
 	if (idev->info->irq >= 0) {
 		ret = request_irq(idev->info->irq, uio_interrupt,
 				  idev->info->irq_flags, idev->info->name, idev);
@@ -640,7 +642,6 @@
 			goto err_request_irq;
 	}
 
-	info->uio_dev = idev;
 	return 0;
 
 err_request_irq:

--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="add-userspace-howto-to-uio-doc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="add-userspace-howto-to-uio-doc.patch"

Index: linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/uio-howto.tmpl	2007-04-29 22:17:45.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl	2007-04-30 00:15:38.000000000 +0200
@@ -30,6 +30,12 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.3</revnumber>
+	<date>2007-04-29</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added section about userspace drivers.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.2</revnumber>
 	<date>2007-02-13</date>
 	<authorinitials>hjk</authorinitials>
@@ -484,14 +490,121 @@
 
 </sect1>
 
+<sect1 id="userspace_driver" xreflabel="Writing a driver in user space">
+<?dbhtml filename="userspace_driver.html"?>
+<title>Writing a driver in userspace</title>
+	<para>
+	Once you have a working kernel module for your hardware, you can
+	write the userspace part of your driver. You don't need any special
+	libraries, your driver can be written in any reasonable language,
+	you can use floating point numbers and so on. In short, you can
+	use all the tools and libraries you'd normally use for writing a
+	userspace application.
+	</para>
+
+<sect2 id="getting_uio_information">
+<title>Getting information about your UIO device</title>
+	<para>
+	Information about all UIO devices is available in sysfs. The
+	first thing you should do in your driver is check
+	<varname>name</varname> and <varname>version</varname> to
+	make sure your talking to the right device and that its kernel
+	driver has the version you expect.
+	</para>
+	<para>
+	You should also make sure that the memory mapping you need
+	exists and has the size you expect.
+	</para>
+	<para>
+	There is a tool called <varname>lsuio</varname> that lists
+	UIO devices and their attributes. It is available here:
+	</para>
+	<para>
+	<ulink url="http://www.osadl.org/projects/downloads/UIO/user/">
+		http://www.osadl.org/projects/downloads/UIO/user/</ulink>
+	</para>
+	<para>
+	With <varname>lsuio</varname> you can quickly check if your
+	kernel module is loaded and which attributes it exports.
+	Have a look at the manpage for details.
+	</para>
+	<para>
+	The source code of <varname>lsuio</varname> can serve as an
+	example for getting information about an UIO device.
+	The file <filename>uio_helper.c</filename> contains a lot of
+	functions you could use in your userspace driver code.
+	</para>
+</sect2>
+
+<sect2 id="mmap_device_memory">
+<title>mmap() device memory</title>
+	<para>
+	After you made sure you've got the right device with the
+	memory mappings you need, all you have to do is to call
+	<function>mmap()</function> to map the device's memory
+	to userspace.
+	</para>
+	<para>
+	The parameter <varname>offset</varname> of the
+	<function>mmap()</function> call has a special meaning
+	for UIO devices: It is used to select which mapping of
+	your device you want to map. To map the memory of
+	mapping N, you have to use N times the page size as
+	your offset:
+	</para>
+<programlisting format="linespecific">
+	offset = N * getpagesize();
+</programlisting>
+	<para>
+	N starts from zero, so if you've got only one memory
+	range to map, set <varname>offset = 0</varname>.
+	A drawback of this technique is that memory is always
+	mapped beginning with its start address.
+	</para>
+</sect2>
+
+<sect2 id="wait_for_interrupts">
+<title>Waiting for interrupts</title>
+	<para>
+	After you successfully mapped your devices memory, you
+	can access it like an ordinary array. Usually, you will
+	perform some initialization. After that, your hardware
+	starts working and will generate an interrupt as soon
+	as it's finished, has some data available, or needs your
+	attention because an error occured.
+	</para>
+	<para>
+	<filename>/dev/uioX</filename> is a read-only file. A
+	<function>read()</function> will always block until an
+	interrupt occurs. There is only one legal value for the
+	<varname>count</varname> parameter of
+	<function>read()</function>, and that is the size of a
+	signed 32 bit integer (4). Any other value for
+	<varname>count</varname> causes <function>read()</function>
+	to fail. The signed 32 bit integer read is the interrupt
+	count of your device. If the value is one more than the value
+	you read the last time, everything is OK. If the difference
+	is greater than one, you missed interrupts.
+	</para>
+	<para>
+	You can also use <function>select()</function> on
+	<filename>/dev/uioX</filename>.
+	</para>
+</sect2>
+
+</sect1>
+
 <appendix id="app1">
 <title>Further information</title>
 <itemizedlist>
 	<listitem><para>
+			<ulink url="http://www.osadl.org">
+				OSADL homepage.</ulink>
+		</para></listitem>
+	<listitem><para>
 		<ulink url="http://www.linutronix.de">
 		 Linutronix homepage.</ulink>
 		</para></listitem>
-	<listitem><para>...</para></listitem>
 </itemizedlist>
 </appendix>
 

--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="ioremap-in-uio-hilscher-cif.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ioremap-in-uio-hilscher-cif.patch"

Index: linux-2.6.22-rc/drivers/uio/uio_cif.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio_cif.c	2007-04-29 21:34:45.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio_cif.c	2007-04-29 21:36:31.000000000 +0200
@@ -64,9 +64,8 @@
 	info->mem[0].addr = pci_resource_start(dev, 0);
 	if (!info->mem[0].addr)
 		goto out_release;
-	info->mem[0].internal_addr = ioremap_nocache(
-						pci_resource_start(dev, 0),
-						pci_resource_len(dev, 0) );
+	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
+					     pci_resource_len(dev, 0) );
 	if (!info->mem[0].internal_addr)
 		goto out_release;
 

--Boundary-00=_ROYOGBJ7SMXhVKb
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-uio_read-type-problem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-uio_read-type-problem.patch"

Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-04-28 22:46:34.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-04-28 22:59:40.000000000 +0200
@@ -264,7 +264,7 @@
 
 struct uio_listener {
 	struct uio_device *dev;
-	int event_count;
+	s32 event_count;
 };
 
 static int uio_open(struct inode *inode, struct file *filep)
@@ -345,12 +345,12 @@
 	struct uio_device *idev = listener->dev;
 	DECLARE_WAITQUEUE(wait, current);
 	ssize_t retval;
-	int event_count;
+	s32 event_count;
 
 	if (idev->info->irq == UIO_IRQ_NONE)
 		return -EIO;
 
-	if (count != sizeof(int))
+	if (count != sizeof(s32))
 		return -EINVAL;
 
 	add_wait_queue(&idev->wait, &wait);

--Boundary-00=_ROYOGBJ7SMXhVKb--
