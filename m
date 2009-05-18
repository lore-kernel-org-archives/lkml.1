Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZERPM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZERPM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZERPMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:12:18 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:22413 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZERPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=K3Ii7telP2jDEwyjlur13Qs6tEArTPOOTYPfE7LnBbU0gkc5yRuuH1f4eFc2ZAXcR1
         Mjz7zsTPS0c1XSGvdaUCmzsv4N0hhE0+PdVVj6TJvD94cI6YBEOep+ZUMSceVGuKZ4HN
         1UkJZIWBBTWe8gTDqpp4+moSMlsyAq/7eGdEw=
Message-ID: <4A117ACB.8070008@gmail.com>
Date: Mon, 18 May 2009 11:12:11 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davide@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v9] kvm: add support for irqfd
References: <20090518143802.20836.46033.stgit@dev.haskins.net>
In-Reply-To: <20090518143802.20836.46033.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig71241399A4761B6F7BBD87BD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig71241399A4761B6F7BBD87BD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (This is v9, applies to kvm.git:2ffc3882)
>
> KVM provides a complete virtual system environment for guests, includin=
g
> support for injecting interrupts modeled after the real exception/inter=
rupt
> facilities present on the native platform (such as the IDT on x86).
> Virtual interrupts can come from a variety of sources (emulated devices=
,
> pass-through devices, etc) but all must be injected to the guest via
> the KVM infrastructure.  This patch adds a new mechanism to inject a sp=
ecific
> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal s=
ignal
> on the irqfd (using eventfd semantics from either userspace or kernel) =
will
> translate into an injected interrupt in the guest at the next available=

> interrupt window.
>
> [ Changelog:
>
>    v9:
>         *) Fixed a bug in deassign where we could deadlock with the way=

>            flush_work was being used (Thanks to Marcelo Tosatti's for s=
potting
>            this bug).
>         *) Rebased to kvm.git:2ffc3882
>
>    v8:
> 	*) Re-seperated irqfd and iofd (now called iosignalfd) into two=20
>   	   distinct series.
>         *) We compare both the fd/file and gsi on deassign
>         *) De-assign is exhaustive (to support multiple associations in=
 the
>            future)
>         *) s/KVM_CAP_EVENTFD/KVM_CAP_IRQFD
>
>    v7:
>         *) Added "iofd" to allow PIO/MMIO writes to generate an eventfd=

>            signal.  This was previously discussed as "hypercallfd", but=

>            since explicit hypercalls are not looking to be very popular=
,
>            and based on the fact that they were not going to carry payl=
oad
>            anyway, I named them "iofd".
>         *) Generalized some of the code so that irqfd and iofd could be=

>            logically grouped together.  For instance
>            s/KVM_CAP_IRQFD/KVM_CAP_EVENTFD and virt/kvm/irqfd.c becomes=

> 	   virt/kvm/eventfd.c
>         *) Added support for "deassign" operations to ensure we can pro=
perly
>            support hot-unplug.
> 	*) Reinstated the eventfd EXPORT_SYMBOL patch since we need it again
>            for supporting iofd.
>         *) Rebased to kvm.git:b5e725fa
>
>    v6:
>         *) Moved eventfd creation back to userspace, per Avi's request
>         *) Dropped no longer necessary supporting patches from series
>         *) Rebased to kvm.git:833367b57
>
>    v5:
>         *) Added padding to the ioctl structure
>         *) Added proper ref-count increment to the file before returnin=
g
>            success. (Needs review by Al Viro, Davide Libenzi)
> 	*) Cleaned up error-handling path to make sure we remove ourself
> 	   from the waitq if necessary.
>         *) Make sure we only add ourselves to kvm->irqfds if successful=

>            creating the irqfd in the first place.
> 	*) Rebased to kvm.git:66b0aed4
>
>    v4:
>         *) Changed allocation model to create the new fd last, after
>            we get past the last potential error point by using Davide's=

>            new eventfd_file_create interface (Al Viro, Davide Libenzi)
> 	*) We no longer export sys_eventfd2() since it is replaced
>            functionally with eventfd_file_create();
>         *) Rebased to kvm.git:7da2e3ba
>
>    v3:
>         *) The kernel now allocates the eventfd (need to export sys_eve=
ntfd2)
>         *) Added a flags field for future expansion to kvm_irqfd()
>         *) We properly toggle the irq level 1+0.
>         *) We re-use the USERSPACE_SRC_ID instead of creating our own
> 	*) Properly check for failures establishing a poll-table with eventfd
> 	*) Fixed fd/file leaks on failure
> 	*) Rebased to lateste kvm.git::41b76d8d04
>
>    v2:
> 	*) Dropped notifier_chain based callbacks in favor of
> 	   wait_queue_t::func and file::poll based callbacks (Thanks to
> 	   Davide for the suggestion)
>
>    v1:
>         *) Initial release
>
> ]
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  arch/x86/kvm/Makefile    |    2=20
>  arch/x86/kvm/x86.c       |    1=20
>  include/linux/kvm.h      |   11 ++
>  include/linux/kvm_host.h |    4 +
>  virt/kvm/eventfd.c       |  224 ++++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/kvm_main.c      |   11 ++
>  6 files changed, 252 insertions(+), 1 deletions(-)
>  create mode 100644 virt/kvm/eventfd.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b43c4ef..4d50904 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -3,7 +3,7 @@
>  #
> =20
>  common-objs =3D $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
> -                coalesced_mmio.o irq_comm.o)
> +                coalesced_mmio.o irq_comm.o eventfd.o)
>  ifeq ($(CONFIG_KVM_TRACE),y)
>  common-objs +=3D $(addprefix ../../../virt/kvm/, kvm_trace.o)
>  endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 44e87a5..123e833 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1026,6 +1026,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_REINJECT_CONTROL:
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
> +	case KVM_CAP_IRQFD:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 3db5d8d..a1ecc6a 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -415,6 +415,7 @@ struct kvm_trace_rec {
>  #define KVM_CAP_ASSIGN_DEV_IRQ 29
>  /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
>  #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
> +#define KVM_CAP_IRQFD 31
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> @@ -454,6 +455,15 @@ struct kvm_irq_routing {
> =20
>  #endif
> =20
> +#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> +
> +struct kvm_irqfd {
> +	__u32 fd;
> +	__u32 gsi;
> +	__u32 flags;
> +	__u8  pad[20];
> +};
> +
>  /*
>   * ioctls for VM fds
>   */
> @@ -498,6 +508,7 @@ struct kvm_irq_routing {
>  #define KVM_ASSIGN_SET_MSIX_ENTRY \
>  			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assign=
ed_irq)
> +#define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)=

> =20
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8f410d3..3b6caf5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -134,6 +134,7 @@ struct kvm {
>  	struct list_head vm_list;
>  	struct kvm_io_bus mmio_bus;
>  	struct kvm_io_bus pio_bus;
> +	struct list_head irqfds;
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
>  	atomic_t users_count;
> @@ -528,4 +529,7 @@ static inline void kvm_free_irq_routing(struct kvm =
*kvm) {}
> =20
>  #endif
> =20
> +int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
> +void kvm_irqfd_release(struct kvm *kvm);
> +
>  #endif
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> new file mode 100644
> index 0000000..41897f9
> --- /dev/null
> +++ b/virt/kvm/eventfd.c
> @@ -0,0 +1,224 @@
> +/*
> + * kvm eventfd support - use eventfd objects to signal various KVM eve=
nts
> + *
> + * Copyright 2009 Novell.  All Rights Reserved.
> + *
> + * Author:
> + *	Gregory Haskins <ghaskins@novell.com>
> + *
> + * This file is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundat=
ion,
> + * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/workqueue.h>
> +#include <linux/syscalls.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +
> +/*
> + * -------------------------------------------------------------------=
-
> + * irqfd: Allows an fd to be used to inject an interrupt to the guest
> + *
> + * Credit goes to Avi Kivity for the original idea.
> + * -------------------------------------------------------------------=
-
> + */
> +struct _irqfd {
> +	struct kvm               *kvm;
> +	int                       gsi;
> +	struct file              *file;
> +	struct list_head          list;
> +	poll_table                pt;
> +	wait_queue_head_t        *wqh;
> +	wait_queue_t              wait;
> +	struct work_struct        work;
> +};
> +
> +static void
> +irqfd_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);
> +	struct kvm *kvm =3D irqfd->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int
> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
> +
> +	/*
> +	 * The wake_up with interrupts disabled.  Therefore we need to defer
> +	 * the IRQ injection until later since we need to acquire the
> +	 * kvm->lock to do so.
> +	 */
> +	schedule_work(&irqfd->work);
> +
> +	return 0;
> +}
> +
> +static void
> +irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
> +			poll_table *pt)
> +{
> +	struct _irqfd *irqfd =3D container_of(pt, struct _irqfd, pt);
> +
> +	irqfd->wqh =3D wqh;
> +	add_wait_queue(wqh, &irqfd->wait);
> +}
> +
> +static int
> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file =3D NULL;
> +	int ret;
> +
> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm =3D kvm;
> +	irqfd->gsi =3D gsi;
> +	INIT_LIST_HEAD(&irqfd->list);
> +	INIT_WORK(&irqfd->work, irqfd_inject);
> +
> +	/*
> +	 * Embed the file* lifetime in the irqfd.
> +	 */
> +	file =3D fget(fd);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	/*
> +	 * Install our own custom wake-up handling so we are notified via
> +	 * a callback whenever someone signals the underlying eventfd
> +	 */
> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> +
> +	ret =3D file->f_op->poll(file, &irqfd->pt);
> +	if (ret < 0)
> +		goto fail;
> +
> +	irqfd->file =3D file;
> +
> +	mutex_lock(&kvm->lock);
> +	list_add_tail(&irqfd->list, &kvm->irqfds);
> +	mutex_unlock(&kvm->lock);
> +
> +	return 0;
> +
> +fail:
> +	if (irqfd->wqh)
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +
> +	if (file && !IS_ERR(file))
> +		fput(file);
> +
> +	kfree(irqfd);
> +	return ret;
> +}
> +
> +static void
> +irqfd_release(struct _irqfd *irqfd)
> +{
> +	/*
> +	 * The ordering is important.  We must remove ourselves from the wqh
> +	 * first to ensure no more event callbacks are issued, and then flush=

> +	 * any previously scheduled work prior to freeing the memory
> +	 */
> +	remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +
> +	flush_work(&irqfd->work);
> +
> +	fput(irqfd->file);
> +	kfree(irqfd);
> +}
> +
> +static struct _irqfd *irqfd_remove(struct kvm *kvm, struct file *file,=
 int gsi)
> +{
> +	struct _irqfd *irqfd;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/*
> +	 * linear search isn't brilliant, but this should be a infrequent
> +	 * operation and the list should not grow very large
> +	 */
> +	list_for_each_entry(irqfd, &kvm->irqfds, list) {
> +		if (irqfd->file !=3D file || irqfd->gsi !=3D gsi)
> +			continue;
> +
> +		list_del(&irqfd->list);
> +		mutex_unlock(&kvm->lock);
> +
> +		return irqfd;
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +
> +	return NULL;
> +}
> +
> +static int
> +kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file;
> +
> +	file =3D fget(fd);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	while ((irqfd =3D irqfd_remove(kvm, file, gsi)))
> +		/*
> +		 * We remove the item from the list under the lock, but we
> +		 * free it outside the lock to avoid deadlocking with the
> +		 * flush_work and the work_item taking the lock
> +		 */
> +		irqfd_release(irqfd);
> +
> +	fput(file);
> +
> +	return -ENOENT;
>  =20

More slop.  I shouldn't send patches out first thing Monday morning, I
guess.

Here is my current delta queued for v10.  I will wait for some feedback
on v9 before cutting it:

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 41897f9..5e07e8b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -154,7 +154,8 @@ irqfd_release(struct _irqfd *irqfd)
        kfree(irqfd);
 }
=20
-static struct _irqfd *irqfd_remove(struct kvm *kvm, struct file *file,
int gsi)
+static struct _irqfd *
+irqfd_remove(struct kvm *kvm, struct file *file, int gsi)
 {
        struct _irqfd *irqfd;
=20
@@ -184,22 +185,25 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi=
)
 {
        struct _irqfd *irqfd;
        struct file *file;
+       int count =3D 0;
=20
        file =3D fget(fd);
        if (IS_ERR(file))
                return PTR_ERR(file);
=20
-       while ((irqfd =3D irqfd_remove(kvm, file, gsi)))
+       while ((irqfd =3D irqfd_remove(kvm, file, gsi))) {
                /*
                 * We remove the item from the list under the lock, but w=
e
                 * free it outside the lock to avoid deadlocking with the=

                 * flush_work and the work_item taking the lock
                 */
                irqfd_release(irqfd);
+               count++;
+       }
=20
        fput(file);
=20
-       return -ENOENT;
+       return count ? count : -ENOENT;
 }

> +}
> +
> +int
> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> +{
> +	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
> +		return kvm_deassign_irqfd(kvm, fd, gsi);
> +
> +	return kvm_assign_irqfd(kvm, fd, gsi);
> +}
> +
> +void
> +kvm_irqfd_release(struct kvm *kvm)
> +{
> +	struct _irqfd *irqfd, *tmp;
> +
> +	/* don't bother with the lock..we are shutting down */
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> +		list_del(&irqfd->list);
> +		irqfd_release(irqfd);
> +	}
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index bebfe59..b58837d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -983,6 +983,7 @@ static struct kvm *kvm_create_vm(void)
>  	atomic_inc(&kvm->mm->mm_count);
>  	spin_lock_init(&kvm->mmu_lock);
>  	kvm_io_bus_init(&kvm->pio_bus);
> +	INIT_LIST_HEAD(&kvm->irqfds);
>  	mutex_init(&kvm->lock);
>  	kvm_io_bus_init(&kvm->mmio_bus);
>  	init_rwsem(&kvm->slots_lock);
> @@ -1034,6 +1035,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	spin_lock(&kvm_lock);
>  	list_del(&kvm->vm_list);
>  	spin_unlock(&kvm_lock);
> +	kvm_irqfd_release(kvm);
>  	kvm_free_irq_routing(kvm);
>  	kvm_io_bus_destroy(&kvm->pio_bus);
>  	kvm_io_bus_destroy(&kvm->mmio_bus);
> @@ -2210,6 +2212,15 @@ static long kvm_vm_ioctl(struct file *filp,
>  	}
>  #endif
>  #endif /* KVM_CAP_IRQ_ROUTING */
> +	case KVM_IRQFD: {
> +		struct kvm_irqfd data;
> +
> +		r =3D -EFAULT;
> +		if (copy_from_user(&data, argp, sizeof data))
> +			goto out;
> +		r =3D kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
> +		break;
> +	}
>  	default:
>  		r =3D kvm_arch_vm_ioctl(filp, ioctl, arg);
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig71241399A4761B6F7BBD87BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoRessACgkQP5K2CMvXmqFgUwCeIzXYT1GUKH5w8klhiJaIIGLt
UbEAoIrpXfCO2YWYDnfRM/Ls0plPHh+D
=PnUe
-----END PGP SIGNATURE-----

--------------enig71241399A4761B6F7BBD87BD--
