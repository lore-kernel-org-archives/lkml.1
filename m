Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYKNQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYKNQr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKNQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:47:21 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57101 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYKNQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:47:21 -0500
Date: Fri, 14 Nov 2008 10:47:17 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: Re: [PATCH 5/5] eCryptfs: Filename Encryption: mount option
Message-ID: <20081114164717.GD6624@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104214313.GE6677@halcrowt61p.austin.ibm.com> <20081106141304.b675cb9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141304.b675cb9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:13:04PM -0800, Andrew Morton wrote:
> On Tue, 4 Nov 2008 15:43:13 -0600
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > Enable mount-wide filename encryption by providing the Filename
> > Encryption Key (FNEK) signature as a mount option. Note that the
> > ecryptfs-utils userspace package versions 61 or later support this
> > option.
> 
> A usage example would, as always, be useful here.

When mounting with ecryptfs-utils version 61 or later, the mount
helper will detect the availability of the passphrase-based filename
encryption in the kernel (via the eCryptfs sysfs handle) and query the
user interactively as to whether or not he wants to enable the feature
for the mount. If the user enables filename encryption, the mount
helper will then prompt for the FNEK signature that the user wishes to
use, suggesting by default the signature for the mount passphrase that
the user has already entered for encrypting the file contents.

When not using the mount helper, the user can specify the signature
for the passphrase key with the ecryptfs_fnek_sig= mount option. This
key must be available in the user's keyring. The mount helper usually
takes care of this step. If, however, the user is not mounting with
the mount helper, then he will need to enter the passphrase key into
his keyring with some other utility prior to mounting, such as
ecryptfs-manager.

> Do we actually provide a secure key on the command line?  If so, do
> any special steps need to be taken to prevent unauthorised viewing
> of it?  Fancy things like `cat /proc/mounts' :)

The mount helper does things correctly by default. Never at any time
does anything provide an actual secret value to eCryptfs as a mount
parameter.
