Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbYHEQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbYHEQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbYHEQz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:55:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4246 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752985AbYHEQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:55:27 -0400
Date: Tue, 5 Aug 2008 18:47:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Russ Anderson <rja@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for partitioning and system serial number on SGI UV
Message-ID: <20080805164752.GB7426@ucw.cz>
References: <20080731200002.GC25715@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731200002.GC25715@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-31 15:00:02, Russ Anderson wrote:
> x86 BIOS interface for partitioning and system serial number on SGI UV
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>


> +static int licenseID_show(struct seq_file *s, void *p)
> +{
> +	seq_printf(s, "0x%llx\n", sn_partition_serial_number_val());
> +	return 0;
> +}
> +
> +static int licenseID_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, licenseID_show, NULL);
> +}
> +
> +static int coherence_id_show(struct seq_file *s, void *p)
> +{
> +	seq_printf(s, "%d\n", partition_coherence_id());
> +
> +	return 0;
> +}
> +
> +static int coherence_id_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, coherence_id_show, NULL);
> +}
> +
> +static const struct file_operations proc_partition_id_fops = {
> +	.open		= partition_id_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations proc_system_sn_fops = {
> +	.open		= system_serial_number_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations proc_license_id_fops = {
> +	.open		= licenseID_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations proc_coherence_id_fops = {
> +	.open		= coherence_id_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};

...serial numbers do not belong to /proc. Plus I'm not sure if stuff
like licenseIDs even belongs to Linux. What is it good for?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
