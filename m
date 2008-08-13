Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYHMKpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYHMKpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYHMKo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:44:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17875 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYHMKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w+jf3+aOEuqP9/zQHNkvNScnlYnd81g4DijuqzuLobR2K/DJ59pjBE7ALylqki1eQ3
         2dq5d5sAARyHhQNjNe4G6Mdu8sG2LIbLzVnEso1AcV3ygyexia1xvfbryBj4ihvhHbf+
         g6UHA9Tn5+cH/qi8OkUedOG7mF2uAtD4IwrGQ=
Message-ID: <e7d8f83e0808130344x29fcb9aja00ce3f64a95ef7b@mail.gmail.com>
Date: Wed, 13 Aug 2008 20:44:54 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Mimi Zohar" <zohar@us.ibm.com>,
       serue@linux.vnet.ibm.com, "James Morris" <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mimi Zohar" <zohar@linux.vnet.ibm.com>
In-Reply-To: <20080812192925.GC18034@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080808184349.999902616@linux.vnet.ibm.com>
	 <1218221761.4444.13.camel@localhost.localdomain>
	 <20080809185340.GC22905@infradead.org>
	 <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
	 <20080811170255.GA2662@us.ibm.com>
	 <OFAC0E3107.C68382CD-ON852574A2.0068E1AD-852574A2.00692623@us.ibm.com>
	 <20080811195645.GA16685@us.ibm.com>
	 <e7d8f83e0808120141s4a0561fdw4919ce6f74d211af@mail.gmail.com>
	 <20080812192925.GC18034@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 5:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Aug 12, 2008 at 06:41:16PM +1000, Peter Dolding wrote:
>> We really do need to get credentials patch in to common store all this
>> permission/secuirty data..  With a section for integrity related
>> entries.
>>
>> Anti-Virus Passes and fails, signed running programs support and so on.
>>
>> Lot of different things need ways of recording integrity status's.
>> Users also need to know if a application does not work is it TPM is it
>> Anti-virus is it lack of signature.
>
> Peter, please read up what the credentials patches do, or how struct
> cred/ucred is used in SVR4 and BSD for the last 20 years.  It is useful,
> but it's not going to help with any of the strange thigns the AV or
> Integrity people are doing.
>
The Issue I have.  By your answer you have not.   Credentials patch
for Linux allows more than the BSD one does.  Linux one is a complete
permission storage replacement.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg02682.html

Note the file credentials one.  That is reused by FS Cache and it
creates fake inodes.  So worst case event LIM blocks a valid file
because its coming from cache.

"vfs_permission and file_permission are just small wrappers around
inode_permission."  No longer both go to inote_permission after the
credentials patch is in.   file_permission instead goes to credentials
struct connected to the inode.  Most calls to inode_permission end up
wrapped to the credentials struct.

Basically by the way Linux Credentials patch is being done.
inode_permission could completely cease to exist.    Completely
replaced by the credentials structure.

Each filesystem having its own cache is one reason why Linux
Credentials Patch is being brought into live.   So a single cache can
store all the need information of the OS and for the file system.
Even better operate on filesystems lacking all the need permission
structs using a userspace program to fill in some of the blanks.

LSM's in Credentials can there own protected data sets since all
alterations to Credentials by the user space deamon have to go past
LSM for approval or rejection.  Linux Credentials only need a extra
protected zone added to cover you LIM needs and AV needs to store
data.

In simple terms permissions stored in inodes is basically deprecated
by Linux's Credentials patch.

Sorting out the Credentials patch is kinda key.   Nothing you AV or
Integrity people is strange to the Linux Credentials patch.   Without
embracing requires more processing when pulling data from a common
cache that has already been AV or Integrity scanned and maintained in
that state.  Now its really designing the struct that should exist in
Credentials.

Peter Dolding
