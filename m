Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbYCTBQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbYCTBQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbYCTBOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:14:24 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1530 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYCTBOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:14:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: [PATCH 4/4] fs/cifs - Align case labels to switch
Date: Wed, 19 Mar 2008 18:11:15 -0700
Message-Id: <1205975475-12708-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1205975475-12708-3-git-send-email-joe@perches.com>
References: <1205975475-12708-1-git-send-email-joe@perches.com>
 <1205975475-12708-2-git-send-email-joe@perches.com>
 <1205975475-12708-3-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/cifssmb.c |   72 +++++++++++++--------------
 fs/cifs/connect.c |    2 +-
 fs/cifs/ioctl.c   |   72 +++++++++++++-------------
 fs/cifs/misc.c    |  144 ++++++++++++++++++++++++++--------------------------
 4 files changed, 144 insertions(+), 146 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ee59e93..b03403a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -186,14 +186,13 @@ small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 				   know whether we can continue or not without
 				   returning to caller to reset file handle */
 				switch (smb_command) {
-					case SMB_COM_READ_ANDX:
-					case SMB_COM_WRITE_ANDX:
-					case SMB_COM_CLOSE:
-					case SMB_COM_FIND_CLOSE2:
-					case SMB_COM_LOCKING_ANDX: {
-						unload_nls(nls_codepage);
-						return -EAGAIN;
-					}
+				case SMB_COM_READ_ANDX:
+				case SMB_COM_WRITE_ANDX:
+				case SMB_COM_CLOSE:
+				case SMB_COM_FIND_CLOSE2:
+				case SMB_COM_LOCKING_ANDX:
+					unload_nls(nls_codepage);
+					return -EAGAIN;
 				}
 			} else {
 				up(&tcon->ses->sesSem);
@@ -331,14 +330,13 @@ smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
 				   know whether we can continue or not without
 				   returning to caller to reset file handle */
 				switch (smb_command) {
-					case SMB_COM_READ_ANDX:
-					case SMB_COM_WRITE_ANDX:
-					case SMB_COM_CLOSE:
-					case SMB_COM_FIND_CLOSE2:
-					case SMB_COM_LOCKING_ANDX: {
-						unload_nls(nls_codepage);
-						return -EAGAIN;
-					}
+				case SMB_COM_READ_ANDX:
+				case SMB_COM_WRITE_ANDX:
+				case SMB_COM_CLOSE:
+				case SMB_COM_FIND_CLOSE2:
+				case SMB_COM_LOCKING_ANDX:
+					unload_nls(nls_codepage);
+					return -EAGAIN;
 				}
 			} else {
 				up(&tcon->ses->sesSem);
@@ -1139,27 +1137,27 @@ static __u16 convert_disposition(int disposition)
 	__u16 ofun = 0;
 
 	switch (disposition) {
-		case FILE_SUPERSEDE:
-			ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
-			break;
-		case FILE_OPEN:
-			ofun = SMBOPEN_OAPPEND;
-			break;
-		case FILE_CREATE:
-			ofun = SMBOPEN_OCREATE;
-			break;
-		case FILE_OPEN_IF:
-			ofun = SMBOPEN_OCREATE | SMBOPEN_OAPPEND;
-			break;
-		case FILE_OVERWRITE:
-			ofun = SMBOPEN_OTRUNC;
-			break;
-		case FILE_OVERWRITE_IF:
-			ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
-			break;
-		default:
-			cFYI(1, ("unknown disposition %d", disposition));
-			ofun =  SMBOPEN_OAPPEND; /* regular open */
+	case FILE_SUPERSEDE:
+		ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
+		break;
+	case FILE_OPEN:
+		ofun = SMBOPEN_OAPPEND;
+		break;
+	case FILE_CREATE:
+		ofun = SMBOPEN_OCREATE;
+		break;
+	case FILE_OPEN_IF:
+		ofun = SMBOPEN_OCREATE | SMBOPEN_OAPPEND;
+		break;
+	case FILE_OVERWRITE:
+		ofun = SMBOPEN_OTRUNC;
+		break;
+	case FILE_OVERWRITE_IF:
+		ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
+		break;
+	default:
+		cFYI(1, ("unknown disposition %d", disposition));
+		ofun =  SMBOPEN_OAPPEND; /* regular open */
 	}
 	return ofun;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ca16fdc..5544fda 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -330,7 +330,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 }
 
 static int
-cifs_demultiplex_thread(void *data);
+cifs_demultiplex_thread(void *data)
 {
 	struct TCP_Server_Info *server = data;
 	int length;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 5c792df..0083f3a 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -63,46 +63,46 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
 #endif /* CONFIG_CIFS_POSIX */
 
 	switch (command) {
-		case CIFS_IOC_CHECKUMOUNT:
-			cFYI(1, ("User unmount attempted"));
-			if (cifs_sb->mnt_uid == current->uid)
-				rc = 0;
-			else {
-				rc = -EACCES;
-				cFYI(1, ("uids do not match"));
-			}
-			break;
+	case CIFS_IOC_CHECKUMOUNT:
+		cFYI(1, ("User unmount attempted"));
+		if (cifs_sb->mnt_uid == current->uid)
+			rc = 0;
+		else {
+			rc = -EACCES;
+			cFYI(1, ("uids do not match"));
+		}
+		break;
 #ifdef CONFIG_CIFS_POSIX
-		case FS_IOC_GETFLAGS:
-			if (CIFS_UNIX_EXTATTR_CAP & caps) {
-				if (pSMBFile == NULL)
-					break;
-				rc = CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
-					&ExtAttrBits, &ExtAttrMask);
-				if (rc == 0)
-					rc = put_user(ExtAttrBits &
-						FS_FL_USER_VISIBLE,
-						(int __user *)arg);
-			}
-			break;
+	case FS_IOC_GETFLAGS:
+		if (CIFS_UNIX_EXTATTR_CAP & caps) {
+			if (pSMBFile == NULL)
+				break;
+			rc = CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
+					    &ExtAttrBits, &ExtAttrMask);
+			if (rc == 0)
+				rc = put_user(ExtAttrBits &
+					      FS_FL_USER_VISIBLE,
+					      (int __user *)arg);
+		}
+		break;
 
-		case FS_IOC_SETFLAGS:
-			if (CIFS_UNIX_EXTATTR_CAP & caps) {
-				if (get_user(ExtAttrBits, (int __user *)arg)) {
-					rc = -EFAULT;
-					break;
-				}
-				if (pSMBFile == NULL)
-					break;
-				/* rc= CIFSGetExtAttr(xid,tcon,pSMBFile->netfid,
-					extAttrBits, &ExtAttrMask);*/
+	case FS_IOC_SETFLAGS:
+		if (CIFS_UNIX_EXTATTR_CAP & caps) {
+			if (get_user(ExtAttrBits, (int __user *)arg)) {
+				rc = -EFAULT;
+				break;
 			}
-			cFYI(1, ("set flags not implemented yet"));
-			break;
+			if (pSMBFile == NULL)
+				break;
+			/* rc= CIFSGetExtAttr(xid,tcon,pSMBFile->netfid,
+					      extAttrBits, &ExtAttrMask);*/
+		}
+		cFYI(1, ("set flags not implemented yet"));
+		break;
 #endif /* CONFIG_CIFS_POSIX */
-		default:
-			cFYI(1, ("unsupported ioctl"));
-			break;
+	default:
+		cFYI(1, ("unsupported ioctl"));
+		break;
 	}
 
 	FreeXid(xid);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a0b02d1..4ddf11c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -663,41 +663,41 @@ cifs_convertUCSpath(char *target, const __le16 *source, int maxlen,
 	for (i = 0, j = 0; i < maxlen; i++) {
 		src_char = le16_to_cpu(source[i]);
 		switch (src_char) {
-			case 0:
-				goto cUCS_out; /* BB check this BB */
-			case UNI_COLON:
-				target[j] = ':';
-				break;
-			case UNI_ASTERIK:
-				target[j] = '*';
-				break;
-			case UNI_QUESTION:
-				target[j] = '?';
-				break;
+		case 0:
+			goto cUCS_out; /* BB check this BB */
+		case UNI_COLON:
+			target[j] = ':';
+			break;
+		case UNI_ASTERIK:
+			target[j] = '*';
+			break;
+		case UNI_QUESTION:
+			target[j] = '?';
+			break;
 			/* BB We can not handle remapping slash until
 			   all the calls to build_path_from_dentry
 			   are modified, as they use slash as separator BB */
-			/* case UNI_SLASH:
-				target[j] = '\\';
-				break;*/
-			case UNI_PIPE:
-				target[j] = '|';
-				break;
-			case UNI_GRTRTHAN:
-				target[j] = '>';
-				break;
-			case UNI_LESSTHAN:
-				target[j] = '<';
-				break;
-			default:
-				len = cp->uni2char(src_char, &target[j],
-						NLS_MAX_CHARSET_SIZE);
-				if (len > 0) {
-					j += len;
-					continue;
-				} else {
-					target[j] = '?';
-				}
+		/* case UNI_SLASH:
+			target[j] = '\\';
+			break;*/
+		case UNI_PIPE:
+			target[j] = '|';
+			break;
+		case UNI_GRTRTHAN:
+			target[j] = '>';
+			break;
+		case UNI_LESSTHAN:
+			target[j] = '<';
+			break;
+		default:
+			len = cp->uni2char(src_char, &target[j],
+					   NLS_MAX_CHARSET_SIZE);
+			if (len > 0) {
+				j += len;
+				continue;
+			} else {
+				target[j] = '?';
+			}
 		}
 		j++;
 		/* make sure we do not overrun callers allocated temp buffer */
@@ -728,49 +728,49 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
 	for (i = 0, j = 0; i < maxlen; j++) {
 		src_char = source[i];
 		switch (src_char) {
-			case 0:
-				target[j] = 0;
-				goto ctoUCS_out;
-			case ':':
-				target[j] = cpu_to_le16(UNI_COLON);
-				break;
-			case '*':
-				target[j] = cpu_to_le16(UNI_ASTERIK);
-				break;
-			case '?':
-				target[j] = cpu_to_le16(UNI_QUESTION);
-				break;
-			case '<':
-				target[j] = cpu_to_le16(UNI_LESSTHAN);
-				break;
-			case '>':
-				target[j] = cpu_to_le16(UNI_GRTRTHAN);
-				break;
-			case '|':
-				target[j] = cpu_to_le16(UNI_PIPE);
-				break;
+		case 0:
+			target[j] = 0;
+			goto ctoUCS_out;
+		case ':':
+			target[j] = cpu_to_le16(UNI_COLON);
+			break;
+		case '*':
+			target[j] = cpu_to_le16(UNI_ASTERIK);
+			break;
+		case '?':
+			target[j] = cpu_to_le16(UNI_QUESTION);
+			break;
+		case '<':
+			target[j] = cpu_to_le16(UNI_LESSTHAN);
+			break;
+		case '>':
+			target[j] = cpu_to_le16(UNI_GRTRTHAN);
+			break;
+		case '|':
+			target[j] = cpu_to_le16(UNI_PIPE);
+			break;
 			/* BB We can not handle remapping slash until
 			   all the calls to build_path_from_dentry
 			   are modified, as they use slash as separator BB */
-			/* case '\\':
-				target[j] = cpu_to_le16(UNI_SLASH);
-				break;*/
-			default:
-				charlen = cp->char2uni(source+i,
-					len_remaining, &temp);
-				/* if no match, use question mark, which
-				at least in some cases servers as wild card */
-				if (charlen < 1) {
-					target[j] = cpu_to_le16(0x003f);
-					charlen = 1;
-				} else
-					target[j] = cpu_to_le16(temp);
-				len_remaining -= charlen;
-				/* character may take more than one byte in the
-				   the source string, but will take exactly two
-				   bytes in the target string */
-				i += charlen;
-				continue;
+		/* case '\\':
+			target[j] = cpu_to_le16(UNI_SLASH);
+			break;*/
+		default:
+			charlen = cp->char2uni(source + i,
+					       len_remaining, &temp);
+			/* if no match, use question mark, which
+			   at least in some cases servers as wild card */
+			if (charlen < 1) {
+				target[j] = cpu_to_le16(0x003f);
+				charlen = 1;
+			} else
+				target[j] = cpu_to_le16(temp);
+			len_remaining -= charlen;
+			/* character may take more than one byte in the
+			   the source string, but will take exactly two
+			   bytes in the target string */
+			i += charlen;
+			continue;
 		}
 		i++; /* move to next char in source string */
 		len_remaining--;
-- 
1.5.4.rc2

