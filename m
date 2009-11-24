Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbZKXIsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbZKXIsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZKXIsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:48:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbZKXIsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:48:02 -0500
Message-ID: <4B0B9E6A.2000000@redhat.com>
Date: Tue, 24 Nov 2009 16:50:50 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@redhat.com>
Subject: Re: [Resend Patch] kexec: allow to shrink reserved memory
References: <20091123093958.4963.38592.sendpatchset@localhost.localdomain> <20091124075813.GA14488@bicker>
In-Reply-To: <20091124075813.GA14488@bicker>
Content-Type: multipart/mixed;
 boundary="------------000307060008070005080003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000307060008070005080003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dan Carpenter wrote:
> On Mon, Nov 23, 2009 at 04:37:02AM -0500, Amerigo Wang wrote:
> [snip]
>> +size_t crash_get_memory_size(void);
> [snip]
>> +static ssize_t kexec_crash_size_show(struct kobject *kobj,
>> +				       struct kobj_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%lu\n", crash_get_memory_size());
>> +}
> 
>   CC      kernel/ksysfs.o
> kernel/ksysfs.c: In function ‘kexec_crash_size_show’:
> kernel/ksysfs.c:106: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘size_t’
> 

Patch below fixes this.

Andrew, could you please fold it in? Thanks!


--------------000307060008070005080003
Content-Type: text/plain;
 name="kexec-free-reserved-memory-delta-fix.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="kexec-free-reserved-memory-delta-fix.diff"

ZGlmZiAtLWdpdCBhL2tlcm5lbC9rc3lzZnMuYyBiL2tlcm5lbC9rc3lzZnMuYwppbmRleCA1
YjkyNzZiLi4zZmVhZjVhIDEwMDY0NAotLS0gYS9rZXJuZWwva3N5c2ZzLmMKKysrIGIva2Vy
bmVsL2tzeXNmcy5jCkBAIC0xMDMsNyArMTAzLDcgQEAgS0VSTkVMX0FUVFJfUk8oa2V4ZWNf
Y3Jhc2hfbG9hZGVkKTsKIHN0YXRpYyBzc2l6ZV90IGtleGVjX2NyYXNoX3NpemVfc2hvdyhz
dHJ1Y3Qga29iamVjdCAqa29iaiwKIAkJCQkgICAgICAgc3RydWN0IGtvYmpfYXR0cmlidXRl
ICphdHRyLCBjaGFyICpidWYpCiB7Ci0JcmV0dXJuIHNwcmludGYoYnVmLCAiJWx1XG4iLCBj
cmFzaF9nZXRfbWVtb3J5X3NpemUoKSk7CisJcmV0dXJuIHNwcmludGYoYnVmLCAiJXp1XG4i
LCBjcmFzaF9nZXRfbWVtb3J5X3NpemUoKSk7CiB9CiBzdGF0aWMgc3NpemVfdCBrZXhlY19j
cmFzaF9zaXplX3N0b3JlKHN0cnVjdCBrb2JqZWN0ICprb2JqLAogCQkJCSAgIHN0cnVjdCBr
b2JqX2F0dHJpYnV0ZSAqYXR0ciwK
--------------000307060008070005080003--
